From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 10 Mar 2015 11:17:28 -0400
Message-ID: <20150310151728.GD28730@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-2-git-send-email-cyphar@cyphar.com>
 <20150309030636.GC13283@htj.duckdns.org>
 <CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
 <20150309065902.GP13283@htj.duckdns.org>
 <CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ@mail.gmail.com>
 <20150310124701.GB28730@htj.duckdns.org>
 <CAOviyai7yJrbGb+uYpK35tw7R-KM0jWQ-BmhpyTqnRFJsVYdUA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Zz5G/ngV1frno9XFmvdxzXgkzYq56w8sbPOT1PYAq7g=;
        b=gnRuHoKBmg8+Ay+HjwjWrIGjXfSsGWfy/OGf90iJPCUb8q/c/2rvqqZqNzf/ILxZqz
         MTsKIAkdqP3rCKkETmZP/Dw6a93bE+hEsDFtlVURm9ARxziKgOgFV7ucTdSpbRr15xwx
         J4/hEJ2cNi89drG+lWURCgnTGns68iXTbOn76syy1g+VRcGzvD7cUAWYRPWiLvMn/N7+
         4WV1O7hUFhBLbkk4dbVLjlkPEf95+L4SYjgQASWbmBup0YYeqJxcQ/vTQABgUFCDzKdu
         mqrJreJjZbc0RcUgVu/EEB1lv4EMMsZFPlwhE9u4oQHDn8vLoKQNG1IypaAaCwGUXSC3
         v7Eg==
Content-Disposition: inline
In-Reply-To: <CAOviyai7yJrbGb+uYpK35tw7R-KM0jWQ-BmhpyTqnRFJsVYdUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Mar 11, 2015 at 01:51:06AM +1100, Aleksa Sarai wrote:
> Actually, I'm fairly sure we can do it all inside cgroup_post_fork() because
> inside cgroup_post_fork() we have access to both the old css_set and the new
> one. Then it's just a matter of reverting and re-applying the charge to the
> hierarchies.

But the problem isn't whether we know both the old and new ones.  The
problem is that we can only abort before the fork commit point and the
"old" one may change between the abort point and post-commit point so
we need to trycharge the old one at the possible abort point, remember
to which css it got charged and then check whether the association has
changed inbetween at the post commit point and readjust if so.

Thanks.

-- 
tejun
