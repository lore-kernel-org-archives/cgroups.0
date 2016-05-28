From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new cgroup namespaces
Date: Sat, 28 May 2016 15:12:16 +1000
Message-ID: <CAOviyag8PA2EqX_8tKq+KoOZ8m6osVyS49GzmuBzN5UDr6zVTA@mail.gmail.com>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
	<573F23D0.2030500@suse.de>
	<20160520152244.GB5632@htj.duckdns.org>
	<1463758258.8091.3.camel@HansenPartnership.com>
	<20160520160352.GC5632@htj.duckdns.org>
	<1463760550.8091.13.camel@HansenPartnership.com>
	<20160520161759.GD5632@htj.duckdns.org>
	<1463761509.8091.19.camel@HansenPartnership.com>
	<20160520165326.GE5632@htj.duckdns.org>
	<1463765326.8091.42.camel@HansenPartnership.com>
	<20160520174938.GF5632@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cyphar-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=UmxHo2rkTPLwCn0H7CNpuL17vlW6z2S2YGfmxq6Z0f8=;
        b=vUX6RLFcxkTsQmlYdXigaFFlwPqiJwBhgooNAY/71snhGBxnhOargB7+YNFNKxjv4P
         LVPNZs39OoPNfrUi2psSucLJDGYKUflVhtNcxSa5vbklaVzEfvOv78bDSI00QDRp2IPa
         aCUcnRrzi9yHQlrSe8hXwxkU0vhs+erNZZw9GDqvybHH5xvcPxm+tOfG/aXXY725q+2G
         ejQnNDA9pmDa4fbhK1RXApT/Rrx9I9vgZWdxoruonYrRA//c/HXaRfNib8UCFu39hk2M
         Oqr/f9F6BNVqtlEzWLB5jNFIqpVb1HQvW+pc9yhwJPlrxUGF7H7+ahOW4NYNJa3CDNOh
         CRmA==
In-Reply-To: <20160520174938.GF5632@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev <dev@opencontainers.org>

Hi Tejun,

>> > Unfortunately, cgroup hierarchy isn't designed to support this sort
>> > of automatic delegation.  Unpriv processes would be able to escape
>> > constraints on v1 with some controllers and on v2 controllers have to
>> > be explicitly enabled by root for delegated scope to have access to
>> > them.
>>
>> Not necessarily.  We also talked about pinning the cgroup tree so that
>> once you enter the cgroup namespace, your current cgroup directory
>> becomes your root, meaning you can't cd back into the ancestors and
>> thus can't write their tasks file, meaning, I think, that it should be
>> impossible to escape ancestor constraints.
>
> I wish it were that clean.  Unfortunately, on v1, some controllers
> (memory and blkio depending on settings, netcls and netprio always)
> simply aren't properly hierarchical and if you have write perm to
> subdirectory you can escape the constraints of your ancestors.
> Whether you can cd back up or not doesn't matter at all, so we can't
> allow delegation by default.

I see two options here, which would allow us to have subtree
delegation without losing hierarchical structure:

1. Don't enable subtree delegation on v1 hierarchies. This would be
the simplest solution, and would cut out most people from using this
feature today -- but it would mean less work around trying to figure
out which hierarchies are safe to delegate (we make it explicit that
when you enable a cgroup on v2 that it must be safe to delegate by an
unprivileged user). We also get the benefit of having the more strict
cgroup.procs write rules.
2. Don't do subtree delegation on hierarchies that aren't
hierarchical. This would have to be done in collaboration with the
controllers (since cgroup core doesn't know which is hierarchical),
and would allow all users of cgroups today to get subtree delegation.

>> > Why does an unpriv NS need to have cgroup delegated to it without
>> > cooperation from cgroup manager?
>>
>> There's actually many answers to this.  The one I'm insterested in is
>> the ability for applications to make use of container features without
>> having to ask permission from some orchestration engine.  The problem
>
> What's "container features"?  Do you mean resource control by that?

Yes. Also the device cgroup. And ignoring the container usecase, it
would be useful to regular programs if they could use cgroup resource
accounting as part of their regular operation. Regular processes can
use rlimits -- why can't they use cgroups without needing cooperation
from an admin process (which makes for security and administration
issues).

>> most people are looking at is how do I prevent the cgroup manager from
>> running as root, because that's a security problem waiting to happen.
>
> It's distributing system wide resources so the top of the tree will
> always be owned by root and delegating subtrees is a fairly minimal
> operation.  I don't see how that would necessarily lead to security
> problems.

If I understand correctly, the security issues James is referring to
is that the cgroup manager could have a bug in it (and because the
cgroup interface is the filesystem, it would probably be some kind of
write-to-any-path bug). This is an intrinsic part of the model of "you
need to have cooperation with an admin process in order to use
resource limiting for your own processes".

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
