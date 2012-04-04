From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Lsf] [RFC] writeback and cgroup
Date: Wed, 4 Apr 2012 10:36:04 -0500
Message-ID: <CAH2r5mtwQa0Uu=_Yd2JywVJXA=OMGV43X_OUfziC-yeVy9BGtQ@mail.gmail.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120404145134.GC12676@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=C5NL1GnoPhUUVzxalbx0VmC8cIF8MHBeBdMQUjeCpmE=;
        b=LoJA2SxH9pj5oWVSKX6tAUE7Wi06lhOdPdB6vaTNWJ61dl6hWlMwexSbhjC4bmH4v8
         1HXaFmJEBFi/bIAhzgKZy49GJIPEGAFQRFUIQ/9BWc5k5gY8e2owcLH2V73XfOxdiyaf
         K8wczu96c8W02d0inTW96hUSmYp05VJh55t4El/xtjjQN/yhpAFe0P+0x//IfO/E7Ff8
         2Z9gGwl2LPU+mM2ta24a3RLJeuVgWb7Iy00ozybbrhpeoQ02i1zeeRQMs7lKprzrDIgC
         IXpHeCzanAR5znArVTmA1UzuxXulj2+QLkFw3LVXkEJqTqbLBSs5V8IsjU666voBOYIn
         R+fQ==
In-Reply-To: <20120404145134.GC12676-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lsf-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 4, 2012 at 9:51 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Apr 03, 2012 at 11:36:55AM -0700, Tejun Heo wrote:
>
> Hi Tejun,
>
> Thanks for the RFC and looking into this issue. Few thoughts inline.
>
> [..]
>> IIUC, without cgroup, the current writeback code works more or less
>> like this. =A0Throwing in cgroup doesn't really change the fundament=
al
>> design. =A0Instead of a single pipe going down, we just have multipl=
e
>> pipes to the same device, each of which should be treated separately=
=2E
>> Of course, a spinning disk can't be divided that easily and their
>> performance characteristics will be inter-dependent, but the place t=
o
>> solve that problem is where the problem is, the block layer.
>
> How do you take care of thorottling IO to NFS case in this model? Cur=
rent
> throttling logic is tied to block device and in case of NFS, there is=
 no
> block device.

Similarly smb2 gets congestion info (number of "credits") returned from
the server on every response - but not sure why congestion
control is tied to the block device when this would create
problems for network file systems

--=20
Thanks,

Steve
