From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Date: Tue, 11 Sep 2012 10:08:37 -0700
Message-ID: <20120911170837.GM7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <504F30DB.60808@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iZ60cPebjF/E/aPf5o/SMjRFhJbX0YiW+ocY2p4/n18=;
        b=RfOJiiSZKwzNI3Ldv/FeJkehEMy7SkVRtVyilcv4MrKuvxqm95gGfo6HsWjBCLwTjT
         q/1H73l/H9sWvz+hmcPKKwjTmusBtFfOJlgtilZZQPpefHqX1l5e/ZRK56K1FSAPr8Nz
         8hgjDWYcZ+6ECZ66V3IvQUq26cwp1J2TdnJGZmJXYEUEkQW7VQoecffqnz9Cmx2sgsRW
         uUlgGEKRr5oRWw0eStuqJBiLo/xDHEKRMTwN7mj2Ql29Sb19zFh39wtcHaWOAnlKcj1P
         dNppvZkd+ajHBX0vK63/9brQi/l72VtgR1CCdXAnL6uxbvVIGRVAI4j/Fu1TSBaZzEXk
         doCw==
Content-Disposition: inline
In-Reply-To: <504F30DB.60808-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Hello, Li.

On Tue, Sep 11, 2012 at 08:38:51PM +0800, Li Zefan wrote:
> > (I tried to document what's broken and how it should be fixed.  If I
> >  got something wrong, please let me know.)
> > 
> 
> So isn't cpuset broken too? child cpuset's cpu mask isn't necessary a subset
> of the parent's if the cpu_exclusive flag is not set.

Heh, didn't even look at that.  Just assumed it was in the same boat
w/ cpu{acct}.  Will take a look.

Thanks.

-- 
tejun
