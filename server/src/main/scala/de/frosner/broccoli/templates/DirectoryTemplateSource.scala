package de.frosner.broccoli.templates

import java.nio.file.{FileSystems, Files}

import com.typesafe.config.ConfigFactory
import de.frosner.broccoli.BroccoliConfiguration
import pureconfig._
import pureconfig.module.enumeratum._
import de.frosner.broccoli.models.{Meta, ParameterInfo, Template}
import play.api.libs.json.Json

import scala.collection.JavaConverters._
import scala.io.Source
import scala.util.Try

/**
  * The template source that loads templates from a directory
  *
  * @param directory The path to the directory with templates
  */
class DirectoryTemplateSource(directory: String) extends TemplateSource {

  private val log = play.api.Logger(getClass)

  /**
    * @return The sequence of templates found in the directory
    */
  def loadTemplates(): Seq[Template] = {
    val rootTemplatesDirectory = FileSystems.getDefault.getPath(directory).toAbsolutePath

    if (!Files.isDirectory(rootTemplatesDirectory)) {
      throw new IllegalStateException(s"Templates directory ${rootTemplatesDirectory} is not a directory")
    }

    log.info(s"Looking for templates in $rootTemplatesDirectory")

    val templateDirectories = Files.list(rootTemplatesDirectory).iterator().asScala.filter(Files.isDirectory(_)).toSeq

    log.info(s"Found ${templateDirectories.length} template directories: ${templateDirectories.mkString(", ")}")

    val templates = templateDirectories.flatMap(templateDirectory => {
      val tryTemplate = Try {
        val templateFileContent = Source.fromFile(templateDirectory.resolve("template.json").toString).mkString
        val templateId = templateDirectory.getFileName.toString
        val metaFile = templateDirectory.resolve("meta.json")
        val templateInfo =
          loadConfigOrThrow[TemplateInfo](ConfigFactory.parseFile(templateDirectory.resolve("template.conf").toFile))
        Template(
          id = templateId,
          template = templateFileContent,
          description = templateInfo.description.getOrElse(s"$templateId template"),
          parameterInfos = templateInfo.parameters.map(_.map(p => p.id -> p).toMap).getOrElse(Map.empty)
        )
      }
      tryTemplate.failed.map(throwable => log.error(s"Parsing template '$templateDirectory' failed: $throwable"))
      tryTemplate.toOption
    })
    log.info(s"Successfully parsed ${templates.length} templates: ${templates.map(_.id).mkString(", ")}")
    templates.sortBy(_.id)
  }
}
