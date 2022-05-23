From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting in keyctl subsys
Date: Mon, 23 May 2022 23:00:12 +0300
Message-ID: <YovnzLqXqEHY6SAC@kernel.org>
References: <1626682667-10771-1-git-send-email-nglaive@gmail.com>
 <0017e4c6-84d8-6d62-2ceb-4851771fec18@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653336113;
        bh=jMzTqIyaDG3t9LHhw88nV+f6YkQIbxRSOEBT5O4w59Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONhwU75pFeTqbDFN+2WHxoD5qBpE7XhjO44tLF6F+evCgxPliKYlF5BPv8Jv55PCz
         cO1b2Mh6HupmDzw8lBP/CuvXp1z5r3FHHLGLdpoF0EiqjKOjhbFUWEaVLgS4WVtFgx
         VftLWMpdyE4iEIFFjtAnNcMi+hh6Gvo1E5ioEuHrqulM+iQQOz6dXAF1QgVSdQbrIW
         HP4xByVJXF5zn0qUgLF8nB33xEpWLDvton4oZ/gaTcjQ/sBi9d8PbTSX20HOMctWFq
         zmAO58GboifVYNLrRVvNAlf4dU0mexI0uhBwqMLVXsIYcZxEP8Cgp8EDFXqWIRmVkD
         5YC2NpUjClrXQ==
Content-Disposition: inline
In-Reply-To: <0017e4c6-84d8-6d62-2ceb-4851771fec18-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Mon, May 23, 2022 at 12:45:09PM +0300, Vasily Averin wrote:
> On 7/19/21 11:17, Yutian Yang wrote:
> > This patch enables accounting for key objects and auth record objects.
> > Allocation of the objects are triggerable by syscalls from userspace.
> > 
> > We have written a PoC to show that the missing-charging objects lead to
> > breaking memcg limits. The PoC program takes around 2.2GB unaccounted
> > memory, while it is charged for only 24MB memory usage. We evaluate the
> > PoC on QEMU x86_64 v5.2.90 + Linux kernel v5.10.19 + Debian buster. All
> > the limitations including ulimits and sysctl variables are set as default.
> > Specifically, we set kernel.keys.maxbytes = 20000 and 
> > kernel.keys.maxkeys = 200.
> > 
> > /*------------------------- POC code ----------------------------*/
> [skipped]
> > /*-------------------------- end --------------------------------*/
> 
> I experimented with "keyctl request2 user debug: X:Y Z" inside the container
> and found that the problem is still relevant and the proposed patch solves it
> correctly.
> 
> I didn't find any complaints about this patch, could someone explain why
> it wasn't applied? If no one objects, I'd like to push it.
> 
> > Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> 
> Thank you,
> 	Vasily Averin
> 
> PS. Should I perhaps resend it?
> 
> > ---
> >  security/keys/key.c              | 4 ++--
> >  security/keys/request_key_auth.c | 4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/security/keys/key.c b/security/keys/key.c
> > index e282c6179..925d85c2e 100644
> > --- a/security/keys/key.c
> > +++ b/security/keys/key.c
> > @@ -279,7 +279,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
> >  		goto no_memory_2;
> >  
> >  	key->index_key.desc_len = desclen;
> > -	key->index_key.description = kmemdup(desc, desclen + 1, GFP_KERNEL);
> > +	key->index_key.description = kmemdup(desc, desclen + 1, GFP_KERNEL_ACCOUNT);
> >  	if (!key->index_key.description)
> >  		goto no_memory_3;
> >  	key->index_key.type = type;
> > @@ -1198,7 +1198,7 @@ void __init key_init(void)
> >  {
> >  	/* allocate a slab in which we can store keys */
> >  	key_jar = kmem_cache_create("key_jar", sizeof(struct key),
> > -			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> > +			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
> >  
> >  	/* add the special key types */
> >  	list_add_tail(&key_type_keyring.link, &key_types_list);
> > diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
> > index 41e973500..ed50a100a 100644
> > --- a/security/keys/request_key_auth.c
> > +++ b/security/keys/request_key_auth.c
> > @@ -171,10 +171,10 @@ struct key *request_key_auth_new(struct key *target, const char *op,
> >  	kenter("%d,", target->serial);
> >  
> >  	/* allocate a auth record */
> > -	rka = kzalloc(sizeof(*rka), GFP_KERNEL);
> > +	rka = kzalloc(sizeof(*rka), GFP_KERNEL_ACCOUNT);
> >  	if (!rka)
> >  		goto error;
> > -	rka->callout_info = kmemdup(callout_info, callout_len, GFP_KERNEL);
> > +	rka->callout_info = kmemdup(callout_info, callout_len, GFP_KERNEL_ACCOUNT);
> >  	if (!rka->callout_info)
> >  		goto error_free_rka;
> >  	rka->callout_len = callout_len;
> 


Acked-by: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

BR, Jarkko
