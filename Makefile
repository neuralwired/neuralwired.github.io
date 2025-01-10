.PHONY: build serve clean run help post publish update drafts

%:
	@:

build:
	@echo "Building site with Hugo..."
	hugo

serve:
	@echo "Starting Hugo development server..."
	hugo server --disableFastRender --buildFuture

run:
	@echo "Cleaning and starting development server..."
	@$(MAKE) clean
	@$(MAKE) serve

clean:
	@echo "Cleaning up all generated files..."
	rm -rf public/ resources/ .hugo_build.lock
	@-hugo --gc > /dev/null 2>&1
	@find . -name ".DS_Store" -delete
	@find . -name "*.log" -delete 
	@rm -rf hugo_stats.json
	@echo "✓ Cleanup complete"

post:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make post <filename>"; \
	else \
		filename="$(filter-out $@,$(MAKECMDGOALS))"; \
		if [[ $$filename == *.md ]]; then \
			hugo new posts/$$filename; \
			echo "✓ Created: content/blog/$$filename"; \
		else \
			hugo new posts/$$filename.md; \
			echo "✓ Created: content/blog/$$filename.md"; \
		fi \
	fi

publish:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make publish <filename>"; \
	else \
		filename="$(filter-out $@,$(MAKECMDGOALS))"; \
		if [[ $$filename == *.md ]]; then \
			sed -i 's/draft: true/draft: false/' content/blog/$$filename; \
			echo "✓ Published: $$filename"; \
		else \
			sed -i 's/draft: true/draft: false/' content/blog/$$filename.md; \
			echo "✓ Published: $$filename.md"; \
		fi \
	fi
	
drafts:
	@echo "Current draft posts:"
	@if grep -q "draft: true" content/blog/*.md 2>/dev/null; then \
		grep -l "draft: true" content/blog/*.md | sed 's|content/blog/||'; \
	else \
		echo "No drafts found."; \
	fi

update:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make update <filename>"; \
	else \
		filename="$(filter-out $@,$(MAKECMDGOALS))"; \
		if [[ $$filename == *.md ]]; then \
			today=$$(date +%Y-%m-%d); \
			sed -i "s/modified: .*$$/modified: $$today/" content/blog/$$filename; \
			echo "✓ Updated modification date for: $$filename to $$today"; \
		else \
			today=$$(date +%Y-%m-%d); \
			sed -i "s/modified: .*$$/modified: $$today/" content/blog/$$filename.md; \
			echo "✓ Updated modification date for: $$filename.md to $$today"; \
		fi \
	fi

help:
	@echo "Available commands:"
	@echo "  make build           - Build the complete site"
	@echo "  make serve           - Start a development server"
	@echo "  make run             - Clean, build, and start development server"
	@echo "  make clean           - Remove all generated files, caches and temporary files"
	@echo "  make post ML         - Create a new blog post named ML.md"
	@echo "  make publish ML      - Publish the draft post ML.md"
	@echo "  make update ML       - Update the modified date of ML.md to today's date"
	@echo "  make drafts          - List all draft posts"
