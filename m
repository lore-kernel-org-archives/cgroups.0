From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: cpuset: Fix 'cpuset.tasks' -> 'tasks'
Date: Fri, 13 Jan 2017 10:27:42 -0700
Message-ID: <20170113102742.686b785c@lwn.net>
References: <9dd9adef5fe4ae283d0510204f556b4390e5a897.1484259596.git.wking@tremily.us>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9dd9adef5fe4ae283d0510204f556b4390e5a897.1484259596.git.wking@tremily.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "W. Trevor King" <wking@tremily.us>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 12 Jan 2017 14:24:27 -0800
"W. Trevor King" <wking@tremily.us> wrote:

> This looks like it was accidentally caught up in e21a05cb (doc:
> cpuset: Update the cpuset flag file, 2010-02-24).
> 
> While I'm touching the line, also fix the posessive "cpusets" ->
> "cpuset's".
> 
> Signed-off-by: W. Trevor King <wking@tremily.us>
> ---
>  Documentation/cgroup-v1/cpusets.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This patch is based on v4.9, but the lines I'm touching don't churn
> much so it should apply to any recent version.
> 
> diff --git a/Documentation/cgroup-v1/cpusets.txt b/Documentation/cgroup-v1/cpusets.txt
> index e5ac5da86..8402dd6 100644
> --- a/Documentation/cgroup-v1/cpusets.txt
> +++ b/Documentation/cgroup-v1/cpusets.txt
> @@ -615,7 +615,7 @@ to allocate a page of memory for that task.
>  
>  If a cpuset has its 'cpuset.cpus' modified, then each task in that cpuset
>  will have its allowed CPU placement changed immediately.  Similarly,
> -if a task's pid is written to another cpusets 'cpuset.tasks' file, then its
> +if a task's pid is written to another cpuset's 'tasks' file, then its

So I'll confess that I don't understand this change.  All of the control
files are referred to as cpuset.whatever in this document; why should
this one, in particular, be different?

Thanks,

jon
