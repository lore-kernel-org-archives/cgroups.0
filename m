From: Philipp Hahn <hahn@univention.de>
Subject: Bug#931111: linux-image-4.9.0-9: Memory "leak" caused by CGroup as used by pam_systemd
Date: Wed, 24 Jul 2019 09:12:50 +0200
Message-ID: <ad6a6d63-b61d-45c2-36f4-e7761bb58a3d@univention.de>
References: <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de> <ad0222ca-5fb0-4177-dc82-ca63f079e942@univention.de> <aa31aa4f4f6c05df3f52f4bd99ceb6f0341ff482.camel@decadent.org.uk> <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de>
Reply-To: Philipp Hahn <hahn@univention.de>, 931111@bugs.debian.org
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.931111.B931111.156395237710014@bugs.debian.org>
In-Reply-To: <aa31aa4f4f6c05df3f52f4bd99ceb6f0341ff482.camel@decadent.org.uk>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-URL: <https://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/ad6a6d63-b61d-45c2-36f4-e7761bb58a3d@univention.de
Content-Type: text/plain; charset="utf-8"
To: Ben Hutchings <ben@decadent.org.uk>
Cc: 931111@bugs.debian.org, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>, =?UTF-8?Q?=E6=AE=B5=E7=86=8A=E6=98=A5?= <duanxiongchun@bytedance.com>

Hello Ben,

Am 24.07.19 um 00:03 schrieb Ben Hutchings:
> On Tue, 2019-07-23 at 15:56 +0200, Philipp Hahn wrote:
> [...]
>> - when the job / session terminates, the directory is deleted by
>> pam_systemd.
>>
>> - but the Linux kernel still uses the CGroup to track kernel internal
>> memory (SLAB objects, pending cache pages, ...?)
>>
>> - inside the kernel the CGroup is marked as "dying", but it is only
>> garbage collected very later on
> [...]
>> I do not know who is at fault here, if it is
>> - the Linux kernel for not freeing those resources earlier
>> - systemd for using CGs in a broken way
>> - someone others fault.
> [...]
> 
> I would say this is a kernel bug.  I think it's the same problem that
> this patch series is trying to solve:
> https://lwn.net/ml/linux-kernel/20190611231813.3148843-1-guro@fb.com/
> 
> Does the description there seem to match what you're seeing?

Yes, Roman Gushchin replied to me by private mail, which I will quote
here to get his response archived in Debian's BTS as well:

> Hi Philipp!
> 
> Thank you for the report!
> 
> I've spent lot of time working on this problem, and the final patchset
> has been merged into 5.3. It implements reparenting of the slab memory
> on cgroup deletion. 5.3 should be much better in reclaiming dying cgroups.
> 
> Unfortunately, the patchset is quite invasive and is based on some
> vmstats changes from 5.2, so it's not trivial to backport it to
> older kernels.
> 
> Also, there is no good workaround, only manually dropping kernel
> caches or disable the kernel memory accounting as a whole.
> 
> Thanks!


段熊春 <duanxiongchun@bytedance.com> also replied and pointed out his
patch-set <https://patchwork.kernel.org/cover/10772277/>, which solved
the problem for them. I more looks like a "hack", was never applied
upstream as Romans work solved the underlying problem.


So should someone™ bite the bullet and try to backport Romans change to
4.19 (and 4.9)? (those are the kernel versions used by Debian).
I'm not a kernel expert myself, especially no mm/cg expert, but have
done some work myself in the past, but I would happily pass on the
chalice to someone more experienced.

Thanks for all your replies - I really appreciate your help.
Philipp

