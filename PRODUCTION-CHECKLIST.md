# Production Deployment Checklist

Use this checklist when deploying TRAVELEASE to production to ensure nothing is missed.

## Pre-Deployment

### Code & Configuration
- [ ] All code changes committed and pushed to version control
- [ ] `.env.example` updated with all required variables
- [ ] Actual `.env` file created with production values (not committed)
- [ ] `NODE_ENV` set to `production`
- [ ] MongoDB connection string updated for production
- [ ] All API keys configured in environment variables
- [ ] Secret keys generated and configured

### Security
- [ ] Removed all hardcoded credentials
- [ ] Changed default passwords
- [ ] Enabled MongoDB authentication
- [ ] Configured firewall rules
- [ ] SSL/TLS certificates obtained and configured
- [ ] CORS configured correctly for production domains
- [ ] Rate limiting implemented (optional but recommended)
- [ ] Input validation on all forms
- [ ] XSS protection enabled
- [ ] Security headers configured

### Database
- [ ] MongoDB backup strategy in place
- [ ] Database indexes created for frequently queried fields
- [ ] Connection pooling configured
- [ ] Database credentials secured
- [ ] Automated backup schedule configured
- [ ] Test backup restoration procedure

### Testing
- [ ] Application tested locally with Docker
- [ ] All features tested manually
- [ ] Database connections verified
- [ ] Chatbot tested and responding correctly
- [ ] API endpoints tested
- [ ] Load testing performed (optional)
- [ ] Security scan completed (optional)

## Deployment

### Infrastructure Setup
- [ ] Cloud account created and configured
- [ ] VM/Container service provisioned
- [ ] Storage configured (for MongoDB data)
- [ ] Network/VPC configured
- [ ] Security groups/firewall configured
- [ ] Domain name purchased (if needed)
- [ ] DNS records configured

### Application Deployment
- [ ] Docker and Docker Compose installed (if using Docker)
- [ ] Repository cloned to server
- [ ] Environment variables configured on server
- [ ] MongoDB container/service started
- [ ] Application containers/services started
- [ ] Services verified running (`docker-compose ps`)

### Web Server Configuration
- [ ] Reverse proxy configured (nginx/Apache)
- [ ] SSL certificate installed
- [ ] HTTP to HTTPS redirect configured
- [ ] Static file serving optimized
- [ ] Gzip compression enabled
- [ ] Cache headers configured

### Domain & SSL
- [ ] Domain DNS A/AAAA records pointing to server
- [ ] SSL certificate installed (Let's Encrypt/Commercial)
- [ ] HTTPS working correctly
- [ ] Mixed content warnings resolved
- [ ] Certificate auto-renewal configured

## Post-Deployment

### Verification
- [ ] Application accessible via domain name
- [ ] HTTPS working correctly
- [ ] Node.js server responding (port 3000 or via proxy)
- [ ] Flask chatbot responding (port 5000 or via proxy)
- [ ] MongoDB connection working
- [ ] All pages loading correctly
- [ ] Forms submitting successfully
- [ ] Chatbot responding to queries
- [ ] YouTube videos loading (if implemented)
- [ ] Weather API working (if implemented)

### Monitoring Setup
- [ ] Application monitoring configured
  - [ ] Uptime monitoring (UptimeRobot, Pingdom)
  - [ ] Error tracking (Sentry, Rollbar)
  - [ ] Log aggregation (ELK, Splunk)
- [ ] Server monitoring configured
  - [ ] CPU usage alerts
  - [ ] Memory usage alerts
  - [ ] Disk space alerts
  - [ ] Network alerts
- [ ] Database monitoring configured
  - [ ] Connection pool monitoring
  - [ ] Query performance monitoring
  - [ ] Storage usage monitoring
- [ ] Alert channels configured (email, SMS, Slack)

### Logging
- [ ] Application logs configured
- [ ] Log rotation configured
- [ ] Centralized logging setup (optional)
- [ ] Error notifications configured
- [ ] Access logs enabled

### Backup & Recovery
- [ ] Database backup script tested
- [ ] Backup storage configured
- [ ] Backup schedule automated
- [ ] Backup retention policy defined
- [ ] Disaster recovery plan documented
- [ ] Recovery procedure tested

### Performance
- [ ] CDN configured for static assets (optional)
- [ ] Database queries optimized
- [ ] Caching strategy implemented
- [ ] Response times acceptable (< 2s for pages)
- [ ] Load balancing configured (if needed)

### Documentation
- [ ] Deployment process documented
- [ ] Server access credentials stored securely
- [ ] Configuration files backed up
- [ ] Runbook created for common operations
- [ ] Incident response plan created
- [ ] Contact information for team members

## Ongoing Maintenance

### Daily
- [ ] Check application uptime
- [ ] Monitor error rates
- [ ] Review critical alerts

### Weekly
- [ ] Review application logs
- [ ] Check disk space usage
- [ ] Monitor database performance
- [ ] Review security alerts

### Monthly
- [ ] Update dependencies (security patches)
- [ ] Review and optimize database queries
- [ ] Test backup restoration
- [ ] Review SSL certificate expiration
- [ ] Analyze performance metrics
- [ ] Review and update documentation

### Quarterly
- [ ] Major dependency updates
- [ ] Security audit
- [ ] Performance optimization review
- [ ] Disaster recovery drill
- [ ] Cost optimization review

## Rollback Plan

In case something goes wrong:

### Immediate Actions
- [ ] Stop deployment process
- [ ] Document the issue
- [ ] Notify team members

### Rollback Steps
- [ ] Keep previous version backup/tag available
- [ ] Document rollback procedure:
  ```bash
  # Stop current version
  docker-compose down
  
  # Checkout previous version
  git checkout <previous-tag>
  
  # Restore previous version
  docker-compose up -d
  
  # Verify rollback successful
  curl http://your-domain.com
  ```
- [ ] Restore database if needed (from backup)
- [ ] Verify old version working
- [ ] Investigate and fix issue
- [ ] Plan re-deployment

## Environment-Specific Checklists

### Docker Deployment
- [ ] Docker installed (version 20.10+)
- [ ] Docker Compose installed (version 1.29+)
- [ ] `docker-compose.yml` configured correctly
- [ ] Volumes for data persistence configured
- [ ] Networks configured
- [ ] Port mappings correct
- [ ] Environment variables passed to containers
- [ ] Container restart policy set (`unless-stopped`)
- [ ] Docker logs accessible

### AWS Deployment
- [ ] IAM roles configured
- [ ] Security groups configured
- [ ] VPC and subnets configured
- [ ] EBS volumes for data (if using EC2)
- [ ] RDS or DocumentDB configured (if using managed DB)
- [ ] CloudWatch alarms set up
- [ ] Auto-scaling configured (optional)
- [ ] Load balancer configured (if needed)
- [ ] Route 53 DNS configured
- [ ] S3 bucket for backups

### Heroku Deployment
- [ ] Heroku CLI installed
- [ ] App created on Heroku
- [ ] Stack set to container
- [ ] Config vars set
- [ ] MongoDB addon added (mLab/MongoDB Atlas)
- [ ] Domain configured
- [ ] SSL certificate configured
- [ ] Dyno size appropriate for traffic
- [ ] Monitoring enabled

### DigitalOcean Deployment
- [ ] Droplet created (appropriate size)
- [ ] Firewall configured
- [ ] Floating IP assigned (optional)
- [ ] Volume attached for data
- [ ] Snapshots enabled
- [ ] Monitoring enabled
- [ ] Alerts configured
- [ ] Spaces for backups (optional)

## Security Hardening Checklist

- [ ] SSH key-only authentication (disable password)
- [ ] Change default SSH port
- [ ] Install and configure fail2ban
- [ ] Keep system updated (`apt update && apt upgrade`)
- [ ] Configure UFW/iptables firewall
- [ ] Disable root login via SSH
- [ ] Regular security updates schedule
- [ ] Enable automatic security updates
- [ ] Configure intrusion detection (optional)
- [ ] Regular security audits

## Compliance & Legal

- [ ] Privacy policy updated
- [ ] Terms of service updated
- [ ] GDPR compliance (if applicable)
- [ ] Cookie consent implemented (if applicable)
- [ ] Data retention policy defined
- [ ] User data handling documented

## Team Onboarding

- [ ] Deployment documentation shared
- [ ] Access credentials distributed securely
- [ ] On-call rotation defined
- [ ] Escalation procedures documented
- [ ] Communication channels established
- [ ] Training materials created

## Success Criteria

Deployment is successful when:
- ✅ Application is accessible via production domain
- ✅ All features working as expected
- ✅ No critical errors in logs
- ✅ Database connections stable
- ✅ Response times acceptable
- ✅ Monitoring and alerts active
- ✅ Backups running successfully
- ✅ Team notified and ready

## Common Issues & Solutions

### Application won't start
- Check logs: `docker-compose logs`
- Verify environment variables
- Check port conflicts
- Verify MongoDB connection

### Database connection fails
- Verify MongoDB is running
- Check connection string
- Verify network connectivity
- Check firewall rules

### High response times
- Check server resources (CPU, RAM)
- Review database query performance
- Check for memory leaks
- Enable caching

### SSL certificate issues
- Verify certificate installation
- Check certificate chain
- Verify DNS propagation
- Check certificate expiration date

## Post-Deployment Testing Script

```bash
#!/bin/bash
# test-deployment.sh

DOMAIN="your-domain.com"

echo "Testing TRAVELEASE Deployment..."

# Test main page
echo "1. Testing main page..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN)
if [ $HTTP_CODE -eq 200 ]; then
    echo "✓ Main page OK"
else
    echo "✗ Main page failed (HTTP $HTTP_CODE)"
fi

# Test chatbot API
echo "2. Testing chatbot API..."
CHATBOT_RESPONSE=$(curl -s -X POST https://$DOMAIN/predict \
    -H "Content-Type: application/json" \
    -d '{"message":"hello"}')
if [ ! -z "$CHATBOT_RESPONSE" ]; then
    echo "✓ Chatbot API OK"
else
    echo "✗ Chatbot API failed"
fi

# Test SSL
echo "3. Testing SSL certificate..."
SSL_EXPIRY=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
echo "✓ SSL expires: $SSL_EXPIRY"

echo "Deployment test completed!"
```

## Notes

- Keep this checklist updated as your deployment process evolves
- Share this checklist with all team members involved in deployment
- Create environment-specific copies if needed
- Document any deviations from this checklist
- Review and improve after each deployment

---

**Last Updated**: 2025-10-21
**Maintained By**: DevOps Team
**Next Review**: Quarterly
