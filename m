From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH][RESEND] cgroup, docs: document the root cgroup behavior
 of cpu and io controllers
Date: Mon, 8 Jan 2018 17:29:42 +0100
Message-ID: <7a45fadb-edc2-f8f2-f0e3-54bd9b24e156@maciej.szmigiero.name>
References: <e9761aed-4f51-07d1-6ede-d695ea5cb61b@maciej.szmigiero.name>
 <20180108121503.GK3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180108121503.GK3668920@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

Hello,

On 08.01.2018 13:15, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 04, 2018 at 10:57:00PM +0100, Maciej S. Szmigiero wrote:
>> Currently, cgroups v2 documentation contains only a generic remark that
>> "How resource consumption in the root cgroup is governed is up to each
>> controller", which isn't really telling users much, who need to dig in the
>> code and / or commit messages to learn the exact behavior.
> 
> I don't think we want to fully guarantee the current behavior.  On the
> scheduler side, I don't think it's likely to change but blkio side
> *might* change.  Can you please collect the root behavior in a separte
> section and clearly note that the behaviors are subject to change?

Will do.

> Thanks.
> 

Maciej
