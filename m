From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 15:48:55 -0400
Message-ID: <20200326194855.GP162390@mtj.duckdns.org>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org>
 <20200326194448.GA133524@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+X43fOowivo9wQhliFx6lnhtIaMEbCHpeVUMSBZZuGY=;
        b=U5JDgEKNA0GkBeHvV5CHdgdArh42FYVrmzkogGBIyPh3UbwY/HtRPl1L7OI8kSvTuM
         t7BJG7ezUxnmgRFbliiaIwK8OBPkiXIeGrhetTsK6rDsWt1lNTKwuMPWLqOYF0Uz07uP
         vlAyx6tjVavmsfFsclBaBM5kI1FLo9fg+4Ct2XX22fBdqTWnySs24i1kyUSGY1vHhgPy
         CuU82/h7zfoXRaJJcIxxSNIjvjQrS8IIf64WfaRfpBpfzEocyTurwPs9dmGXh/+Q/esb
         pdpiaqT4PIpE6gDZyhqhdIScxy7PlNi43u4b6oe1NowK41XpBBOw6RXKLF4zN+sjinb5
         JVnA==
Content-Disposition: inline
In-Reply-To: <20200326194448.GA133524-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kerr <kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Mar 26, 2020 at 03:44:48PM -0400, Joel Fernandes wrote:
> It is not really that big a change. Please go over the patch, we are not
> changing anything with how ->cpus_allowed works and interacts with the rest
> of the system and the scheduler. We have just introduced a new mask to keep
> track of which CPUs were requested without them being affected by hotplug. On
> CPU onlining, we restore the state of ->cpus_allowed as not be affected by
> hotplug.

It's not the code. It's the behavior. I'm not flipping the behavior for
the existing cgroup1 users underneath them at this point. As-is, it's a
hard nack. If you really really really want it, put it behind a mount
option.

-- 
tejun
