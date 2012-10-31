From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Date: Wed, 31 Oct 2012 09:23:30 -0700
Message-ID: <20121031162330.GA2945@htj.dyndns.org>
References: <20121031160430.GD14789@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZrN4MkAp6tZnm+DBPG3wNmpkNnEPvvuOLgtKB+hsy/I=;
        b=n3XbG8sjph2T8g9sI9CMYKh6aq5zaAaNn4wj3ittb/DTh7zUaU02XjylrGGP7LJL/b
         LxiyHqxWISWB+0oCAy7mb8TmXeC61whdtmEENx832JL+6omSp64oIcjNkFG11kJgpGwx
         moNNA1MAjXLLtke8TOnL4PEgPHUCvAeQDvFOH14MnHKzreC9DIgoyqQDPh8tngol87Bd
         UIgBEEtu8wFMVCwUYvymmYgFnuXWuRkTSYIkAZ72tpie+KYnQMhxM5878yNEYemERvrt
         s8OLMLXZbrmlUV5sLPjRYsxxyrSiKXKcLTCABi0DdZZFxMjMkPufMvkNtgvlvv3vCCwX
         BNXg==
Content-Disposition: inline
In-Reply-To: <20121031160430.GD14789@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>, cgroups@vger.kernel.org

On Wed, Oct 31, 2012 at 12:04:30PM -0400, Aristeu Rozanski wrote:
> In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> unchecked. root will not have a parent and trying to use
> device.{allow,deny} will cause problems. For some reason my stressing
> scripts didn't test the root directory so I didn't catch it on my
> regular tests.
> 
> Andrew, Tejun, this patch needs to make Linus tree ASAP or a revert for
> 4cef7299b4786879a3e113e84084a72b24590c5b.

 Acked-by: Tejun Heo <tj@kernel.org>

Andrew, can you please pick this one up?

Thanks.

-- 
tejun
