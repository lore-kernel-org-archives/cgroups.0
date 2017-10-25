From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Wed, 25 Oct 2017 11:50:34 -0400
Message-ID: <db119820-84d4-7ccb-e65a-966d2d7aaf02@redhat.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1507324230-22996-1-git-send-email-longman@redhat.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Mike Galbraith <efault@gmx.de>, Christian Brauner <christian.brauner@canonical.com>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>

On 10/06/2017 05:10 PM, Waiman Long wrote:
> Given the fact that thread mode had been merged into 4.14, it is now
> time to enable cpuset to be used in the default hierarchy (cgroup v2)
> as it is clearly threaded.
>
> The cpuset controller had experienced feature creep since its
> introduction more than a decade ago. Besides the core cpus and mems
> control files to limit cpus and memory nodes, there are a bunch of
> additional features that can be controlled from the userspace. Some of
> the features are of doubtful usefulness and may not be actively used.
>
> After examining the source code of some sample users like systemd,
> libvirt and lxc for their use of those additional features, only
> memory_migrate is used by libvirt.
>
> This patch enables cpuset controller in the default hierarchy with a
> minimal set of features. Currently, only memory_migrate is supported.
> We can certainly add more features to the default hierarchy if there
> is a real user need for them later on.
>
> For features that are actually flags which are set internally, they are
> being combined into a single "cpuset.flags" control file. That includes
> the memory_migrate feature which is the only flag that is currently
> supported. When the "cpuset.flags" file is read, it contains either
> "+mem_migrate" (enabled) or "-mem_migrate" (disabled).
>
> To enable it, use
>
>   # echo +mem_migrate > cpuset.flags
>
> To disable it, use
>
>   # echo -mem_migrate > cpuset.flags
>
> Note that the flag name is changed to "mem_migrate" for better naming
> consistency.
>
> v3:
>  - Further trim the additional features down to just memory_migrate.
>  - Update Documentation/cgroup-v2.txt.
>
> Signed-off-by: Waiman Long <longman@redhat.com>

Ping! Any comment on this patch?

Cheers,
Longman

