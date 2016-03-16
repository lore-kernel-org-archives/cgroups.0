From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup namespaces - mount root
Date: Wed, 16 Mar 2016 14:46:54 -0700
Message-ID: <20160316214654.GK21104@mtj.duckdns.org>
References: <20160311215010.GA5844@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+vUniNWQw0+FFeis0qX9A52Q/f9e/W7RztNbY59Hg+I=;
        b=zvRjvFg+BvyORbKw8GDF9Uv0eGMeqUWWsfgiPG8Q92BozGFiFBgBWR4TvhwD3a7PBy
         VEGQHpRImTmCihiTVrZHTB5iLoEgPGY32mKyZysfS86U59kO597jNgzVIKaAleMU3/wC
         hCr289C8pNO4aYoapEiMJLeTVDcOw8TYw28lB2zjE9lX3t8YFhszF7W1QMW8cT++R/Hy
         xQGnxZgGtcYCqHoc3d0lNu8IsmQaFTNKZznxAuiAQwAZKcqWOg09duw3mbZ7fXdmW6+W
         ttkrdvK2m5txEu5rNqPcVdOLVbI5Huqub/d5LxiiggWA8gi5r08wb+ZZA63khx53EShg
         Xu0w==
Content-Disposition: inline
In-Reply-To: <20160311215010.GA5844-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Serge.

On Fri, Mar 11, 2016 at 03:50:10PM -0600, Serge E. Hallyn wrote:
> 'mount root' field (field 3) in /proc/self/mountinfo will show the
> same thing, the result of awk -F: '/freezer/ { print $3 }' /proc/self/cgroup.

I see.

> I keep waffling between thinking this is a problem that needs to be
> solved, and thinking "don't do that".  But docker at least seems to
> have a problem with it right now, because it uses that field as part
> of its calculation of paths to write to.

Yeah, given that both are used in pretty simliar context, I think
distinguishing them would be a good idea.

> So, do you think it would be worth adding a 'nsroot=' entry in the
> optional fields (next shared:) ?  I would've just sent a patch, but

Yeah, I think so.

> it actually isn't quite as simple as it would seem to find a way to
> get the absolute path during mountinfo_read(), so I thought I'd ask
> before spending more time on it.

Thanks.

-- 
tejun
