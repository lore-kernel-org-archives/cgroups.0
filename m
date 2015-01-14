From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Date: Wed, 14 Jan 2015 17:17:47 +0100
Message-ID: <20150114161747.GH4706@dhcp22.suse.cz>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
 <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Z68E4xRnhoJ8p1YCTEySHzZEtTPA1pRFBXTlkhlJ62s=;
        b=DO0wtY5LZaCozq3WW5yu5xH4SJtr+a0El+EpSvoabEkL7kmSGgthiIDyUp9xPlustN
         soKYxLliqt8QWITlNbYVTBibJynpE34xGY5xKSAijL4J5P3mpT0LnbjPBWCf+71GYIBa
         Xy7JkYFPadPhZNbgXvU7wb2T30K/tJDKTUPLdEkprYsS8Ot9H40Yt9D/Re2dKwJ9jk9t
         dg3Q4zTOJMIteV8vI3zES9jc7eoG3hdsfj9HU3syfD05HE3KfrVPk6D1zUFYTiGTUWeQ
         2l3GeTmkf5oaMa0HKTOR0JQD+iQOJnk9SrT6TpVTdZJPG3sL1CrG1FcFqNGx8C3Ms8vZ
         FLpg==
Content-Disposition: inline
In-Reply-To: <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

I have overlooked the `none' setting...

On Thu 08-01-15 23:15:04, Johannes Weiner wrote:
[...]
> +static int memory_low_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> +	unsigned long low = ACCESS_ONCE(memcg->low);
> +
> +	if (low == 0)
> +		seq_printf(m, "none\n");
> +	else
> +		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
> +
> +	return 0;
> +}

This is really confusing. What if somebody wants to protect a group
from being reclaimed? One possible and natural way would by copying
memory.max value but then `none' means something else completely.

Besides that why to call 0, which has a clear meaning, any other name?

Now that I think about the naming `none' doesn't sound that great for
max resp. high either. If for nothing else then for the above copy
example (who knows what shows up later). Sure, a huge number is bad
as well for reasons you have mentioned in other email. `resource_max'
sounds like a better fit to me. But I am lame at naming.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
