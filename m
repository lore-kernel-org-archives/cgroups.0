From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 18:31:20 +0100
Message-ID: <CAKgNAkhDY09gauX-1Ut4SoL9DEoxj9wJ8SjS6h-Ntc90xeWi1A@mail.gmail.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
 <20180110124407.GA26913@castle.DHCP.thefacebook.com> <20180110140239.GX3668920@devbig577.frc2.facebook.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=COc06EYBdpPM9JtGQYn7Gz9HeW2LW5iTUlsYJ6PtUWw=;
        b=SfZVCeuJc2FmuifSRy0he46ZSG3CRGH3bX5cV6++vqTUIPeDiMLsYXoqm6Ct5OiiZT
         M49O7tSHjIQrg1hFdHqfCDCN5kFsTvil5rjYi4n6wYFNwOT7MQTNm964WRFVFsGUoBwx
         UckXx66KSbdCe+sQNQU/ONNoc1QVHYzxbWq9d3YTT1N5jfXRDwDS8Uu61DvzGTbw2tGQ
         gueC+BOPq+PrXpWOgZkWgBzT4ZPvUg6MTmzK1KeZVIHPG4OxDphEJ0b/rHiPNCA+ZkSN
         zxjSkdKQUWTQSw24HQsFIdnd4Gv0svoalpjns17Xr3izXPc4YJa60OcXqJ8jCtHP35OF
         /ukw==
In-Reply-To: <20180110140239.GX3668920@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

Hello Tejun,

On 10 January 2018 at 15:02, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Jan 10, 2018 at 04:44:14AM -0800, Roman Gushchin wrote:
>> cgroup.threads is not listed because it's not delegatable (doesn't have
>> CFTYPE_NS_DELEGATABLE flag set). I don't know if it was intended or just
>> an accident (I believe the latter).
>
> So, thread mode isn't delegatble.  Marking a cgroup as threaded turns
> that subtree threaded and join the parent's domain, so we can't allow
> delegation roots to be turned threaded - just like we can't mark the
> root cgroup threaded, and I'm not really not sure what it means to
> delegate a portion of threaded subtree.

So, I am confused. According to Documentation/cgroup-v2.txt,
cgoup.threads is delegated:

[[
Model of Delegation
~~~~~~~~~~~~~~~~~~~

A cgroup can be delegated in two ways.  First, to a less privileged
user by granting write access of the directory and its "cgroup.procs",
"cgroup.threads" and "cgroup.subtree_control" files to the user.
Second, if the "nsdelegate" mount option is set, automatically to a
cgroup namespace on namespace creation.
]]

So, is that a mistake in that text file?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
