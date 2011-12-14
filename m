From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] make clone_children a flag
Date: Wed, 14 Dec 2011 10:18:52 -0800
Message-ID: <20111214181852.GB20380@google.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
 <1323614738-7405-4-git-send-email-glommer@parallels.com>
 <20111213153921.GE25802@google.com>
 <4EE80A0D.7090808@cn.fujitsu.com>
 <4EE84B9A.90901@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5CS8sJQm4aSU9zzQeyCI96Sz2iTjPDiPGLcKvn3q5qo=;
        b=UC5j9V/CjynpQcjH+yRF9BFUSWvDYePei7L1MhOqytlNQI7gN9kZ7GNi7JxzCjZlIg
         VyNnoMiEBdxjJwkyDrTRg8k1mUIDW2iNs6o7CG3n5kViXNFawdA5wwlbxkdTUJC1Tfst
         h81DR3nXadRN1fXxIjqcA4O25eIXjgUhzBjFQ=
Content-Disposition: inline
In-Reply-To: <4EE84B9A.90901-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

Hello,

On Wed, Dec 14, 2011 at 11:09:14AM +0400, Glauber Costa wrote:
> That's indeed confusing, and it comes from the fact that we always
> inherit clone_children from the parent - which is sane, IMHO. So
> this flag only has any value in establishing the initial behaviour
> of the top root cgroup. I wonder then if it wouldn't better to just
> be explicit and fail in this case ?

I don't think all current behaviors are sane and if not let's change
them, but those things have to be explicit with proper description and
rationale.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
