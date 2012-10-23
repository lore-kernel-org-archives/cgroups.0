From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: fix invalid rcu dereference
Date: Tue, 23 Oct 2012 15:53:14 +0200
Message-ID: <5086A14A.7000400@suse.cz>
References: <20121022134536.172969567@napanee.usersys.redhat.com> <20121022134536.543579196@napanee.usersys.redhat.com> <508692A8.6090706@suse.cz> <20121023131746.GB14085@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        bh=MBhpvLJiwXiNnvhACKokBm10o1sj4YAiOw8dymbWGhc=;
        b=ji/iPB3EkjqfPXboXvsHamNtY23eBva5/xeC21DZfA7c0rnsItOGJPkD8S26YTQB7Q
         OHWA5Dswp825risV8WmYntVGRERK050zeetPycqt7erxcxoob7qz1bJLQ6O6xi68ompy
         GPapUoDGErn6aIwssHSHZ7RcQvSFtkdOkyeWoXxXQ0JBw2phSItPrBSulWvUrNPlg2LJ
         GjJryxsDyzwSS7wV9Et9iKs9/WL5LON02tHauVzvkVC/+YZC6B5uFnQaVlfQBqyRG7zq
         d4f3qBtr5HjXBJR7nuOZNJMJsep3fNMbE1VhY4UgFDs+Yw5gu3FlWsuAUevlRR5KhdkK
         svHg==
In-Reply-To: <20121023131746.GB14085-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/23/2012 03:17 PM, Aristeu Rozanski wrote:
> On Tue, Oct 23, 2012 at 02:50:48PM +0200, Jiri Slaby wrote:
>> No, I'm *not* the author of the patch... Or at least I don't remember
>> :P. Where did you take it from?
> 
> <1347615612-11450-1-git-send-email-jslaby-AlSwsSmVLrQ@public.gmane.org> 
> Date: Fri, 14 Sep 2012 11:40:12 +0200
> 
> you didn't include a "From:" on your email, so I assumed it was from
> you. it was sent to akpm with others and linux-kernel in cc

Ah, ok, you convinced me that I'm the author of the patch :).


-- 
js
suse labs
