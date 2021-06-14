From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/4] cgroup/cpuset: Allow cpuset to bound displayed cpu
 info
Date: Mon, 14 Jun 2021 16:43:28 -0400
Message-ID: <YMe/cGV4JPbzFRk0@slm.duckdns.org>
References: <20210614152306.25668-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=212ymYp7XEu+lKWxduC+83kiaUY3pqkgv+9qi3641iU=;
        b=ixpntEdyk4n4XpQDDgnK92G2u3+1O1Oz3Fhqal4MiqoQVAoZmarGQIzc1x7iSob77H
         vNzXG5bd7M3JsZPRBHsXNtIVpqpYxAYq+61TxPuyQ2oIhCrqzlXqISfPCgYra4nCNfqe
         3ZOn/WS3+/CArQyHi0AV2aVcy9uk70efLQEPWgAhEPlRauDD66xs/Y6hQMIJHKL/WPub
         zDUT31VW3Eg+meHPP+2TiyzfeRmRBuu7np35feeIqu4XIlmy8etcfa3bgsE6fdmv2EjM
         i/k4a2r3HqU8po5AySg1+/Ss7DP0P4H6lFmsNslpuivserxT92ZaxeqvB0U+0s1x8iJv
         qtBw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210614152306.25668-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin <hpa@zytor.com>, Greg Kroah-Hartman
        <gregkh@linuxfoundation.org>, Rafael J. Wysocki " <rafael@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, x86@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hello,

On Mon, Jun 14, 2021 at 11:23:02AM -0400, Waiman Long wrote:
> The current container management system is able to create the illusion
> that applications running within a container have limited resources and
> devices available for their use. However, one thing that is hard to hide
> is the number of CPUs available in the system. In fact, the container
> developers are asking for the kernel to provide such capability.
> 
> There are two places where cpu information are available for the
> applications to see - /proc/cpuinfo and /sys/devices/system/cpu sysfs
> directory.
> 
> This patchset introduces a new sysctl parameter cpuset_bound_cpuinfo
> which, when set, will limit the amount of information disclosed by
> /proc/cpuinfo and /sys/devices/system/cpu.

The goal of cgroup has never been masquerading system information so that
applications can pretend that they own the whole system and the proposed
solution requires application changes anyway. The information being provided
is useful but please do so within the usual cgroup interface - e.g.
cpuset.stat. The applications (or libraries) that want to determine its
confined CPU availability can locate the file through /proc/self/cgroup.

Thanks.

-- 
tejun
