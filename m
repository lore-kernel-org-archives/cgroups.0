From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH mm v6] mm/tracing: add 'accounted' entry into output of
 allocation tracepoints
Date: Wed, 15 Jun 2022 11:41:48 +0200
Message-ID: <9a4a9afe-bbe1-4cb3-713b-f1e4e6d2a049@suse.cz>
References: <c1676616-1405-5bcb-af02-c1e9cc83dace@openvz.org>
 <c418ed25-65fe-f623-fbf8-1676528859ed@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655286108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6f7LmKgyp4C8f+DMh1UfRQSRSKDECQlQXNjM/3tlkyo=;
        b=rPB+1CRTKgd1xPx+KfMeX7FH++oXL054wTxWh/VeuqEnfRgUvdFyCoe1i9QT9dZHb7dN6+
        SEfh9+QHmzs6BFs0HZFap5dhkOAXUqM/Ow7idrU6Y7xzs5Hd7xFvHEWCN+1HyzTxHbrLPF
        8eDixoxZXMqwKeUHQaWnpB6468MAj8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655286108;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6f7LmKgyp4C8f+DMh1UfRQSRSKDECQlQXNjM/3tlkyo=;
        b=ZSz1y2A0+YrDzowCa3edbEWx/AQMWCa3u9CIIgE0Er5JfKqm+Hk5k6lZYIMcbnYtrImkfG
        ebyR0VSchAMrRNDQ==
Content-Language: en-US
In-Reply-To: <c418ed25-65fe-f623-fbf8-1676528859ed-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/3/22 05:21, Vasily Averin wrote:
> Slab caches marked with SLAB_ACCOUNT force accounting for every
> allocation from this cache even if __GFP_ACCOUNT flag is not passed.
> Unfortunately, at the moment this flag is not visible in ftrace output,
> and this makes it difficult to analyze the accounted allocations.
> 
> This patch adds boolean "accounted" entry into trace output,
> and set it to 'true' for calls used __GFP_ACCOUNT flag and
> for allocations from caches marked with SLAB_ACCOUNT.
> Set it to 'false' if accounting is disabled in configs.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, added to slab/for-5.20/tracing

> 
> ---
> v6:
>  1) subject changed from "tracing:" to "mm/tracing:"
>  2) set flag to 'false' if accounting is disabled in configs

Looks like you forgot the kmem_alloc_node variant, fixed up locally:

--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -94,8 +94,9 @@ DECLARE_EVENT_CLASS(kmem_alloc_node,
                __entry->bytes_alloc    = bytes_alloc;
                __entry->gfp_flags      = (__force unsigned long)gfp_flags;
                __entry->node           = node;
-               __entry->accounted      = (gfp_flags & __GFP_ACCOUNT) ||
-                                         (s && s->flags & SLAB_ACCOUNT);
+               __entry->accounted      = IS_ENABLED(CONFIG_MEMCG_KMEM) ?
+                                         ((gfp_flags & __GFP_ACCOUNT) ||
+                                         (s && s->flags & SLAB_ACCOUNT)) : false;
        ),
 
        TP_printk("call_site=%pS ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d accounted=%s",
