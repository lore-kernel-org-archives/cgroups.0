From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 2/3] make clone_children a flag
Date: Thu, 15 Dec 2011 11:03:38 +0400
Message-ID: <4EE99BCA.1010505@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com> <20111213153921.GE25802@google.com> <4EE80A0D.7090808@cn.fujitsu.com> <4EE84B9A.90901@parallels.com> <20111214181852.GB20380@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111214181852.GB20380@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org, jbottomley@parallels.com, cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com

On 12/14/2011 10:18 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Dec 14, 2011 at 11:09:14AM +0400, Glauber Costa wrote:
>> That's indeed confusing, and it comes from the fact that we always
>> inherit clone_children from the parent - which is sane, IMHO. So
>> this flag only has any value in establishing the initial behaviour
>> of the top root cgroup. I wonder then if it wouldn't better to just
>> be explicit and fail in this case ?
>
> I don't think all current behaviors are sane and if not let's change
> them, but those things have to be explicit with proper description and
> rationale.
>

140 % agree to that. As I said, I wrongly believed it to be functionally 
equivalent when I sent it, but missed the flags remount check.

If you believe the behavior we now get is saner, I can rewrite the 
Changelog and resend it.
