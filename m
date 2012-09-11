From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH UPDATED RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Date: Tue, 11 Sep 2012 13:51:30 -0700
Message-ID: <CAOS58YPmrCrgdunsck78GTeGUCf9CBrS75BRt3wpQUfwMUGpsg@mail.gmail.com>
References: <20120910223125.GC7677@google.com>
	<20120910223355.GD7677@google.com>
	<20120911182356.GR7677@google.com>
	<20120911205027.GA25837@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=C+u15A0/npRxZG+eYPPLgYV0uE400Vero3WZlCN3Ros=;
        b=kOGu1xgZKV+qBe85n7XY0oFsgBe0oEzY+GsCgn317gv9hZLzt+TsvfhQpKeSOcjeuW
         AI0FhZKvR1AS3flLMMPPWbpaksaznFv3LMxSHlqVPj0/IBK8c+cSyOZFbxNAcMsjpWex
         cr75mdNAJfQgjcm6ccbHQE+Ush1oAHAJfHSiYMktUtmbAUphjUMg5DfL5mDxvnT+9CQE
         4K/j+Kf7ow2E+Uaqv7uy1+a1FYnNBvOKNKmKsE2KgeOQwMSelsTGRMwsP7wuA4ZKhj+L
         aJOkbgcoPUcoSWXWkQ1kIzZ8Ndxn5OQMXOCAYUQCmwk4RPfT5YpMGwi7wLHTU7X3JZe1
         zITA==
In-Reply-To: <20120911205027.GA25837-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Hello,

On Tue, Sep 11, 2012 at 1:50 PM, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Tejun,
> On Tue, Sep 11, 2012 at 11:23:56AM -0700, Tejun Heo wrote:
>> +                     /* we're fully hierarchical iff root uses hierarchy */
>
> minor nit: s/iff/if/

That was intentional iff == if and only if. :)

Thanks.

-- 
tejun
