package com.github.andrepenteado.apcash;

import java.util.Locale;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.web.servlet.ServletWebServerFactoryAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.FixedLocaleResolver;

import ch.qos.logback.classic.helpers.MDCInsertingServletFilter;

@SpringBootApplication(exclude = { ServletWebServerFactoryAutoConfiguration.class })
public class ApCashApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(ApCashApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(ApCashApplication.class);
    }

    @Bean
    public LocaleResolver localeResolver() {
        return new FixedLocaleResolver(new Locale("pt", "BR"));
    }

    @Bean
    public MDCInsertingServletFilter mdcInsertingServletFilter() {
        return new MDCInsertingServletFilter();
    }
}
