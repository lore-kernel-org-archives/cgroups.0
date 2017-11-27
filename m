From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 27 Nov 2017 16:47:16 -0500
Message-ID: <91094cf3-ca5c-3871-2a9d-09864c63bf7b@redhat.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
 <20171127210411.GS983427@devbig577.frc2.facebook.com>
 <8a5ba419-2b02-5b6a-462f-34106cc575ab@redhat.com>
 <20171127214232.GT983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127214232.GT983427@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Mike Galbraith <efault@gmx.de>, Christian Brauner <christian.brauner@canonical.com>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>

On 11/27/2017 04:42 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Nov 27, 2017 at 04:19:57PM -0500, Waiman Long wrote:
>>> Let's start just with [e]cpus and [e]mems.  The flags interface looks
>>> fine but the implementations of these features are really bad and
>>> cgroup2 doesn't migrate resources for other controllers either anyway.
>> That is added because the mem_migrate feature is used in libvirt, I
>> think. I am thinking of add a "[EXPERIMENTAL]" tag to the flags to
>> indicate that it is subject to change.
> I see.  Do you happen to know what it's used for and why that's
> necessary just so that we can evaluate it better?  I'm not quite sure
> what adding [EXPERIMENTAL] tag would achieve.  If we expose the
> feature and people use it, we just have to keep it anyway.

The mem_migrate feature will probably enforce better NUMA locality as
the vCPU may move from one physical CPU to another if it is not pinned.

I want to add the experimental tag more in the sense that we are going
to add to the list of the flags in the future than removing an existing
one. Well, I guess we can just say it in the text instead of adding a tag.

Cheers,
Longman
