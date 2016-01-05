From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [Propose] Isolate core_pattern in mnt namespace.
Date: Tue, 5 Jan 2016 14:28:46 +0800
Message-ID: <568B629E.5010806@cn.fujitsu.com>
References: <56729B3D.1040502@cn.fujitsu.com>	<56760F05.3020308@cn.fujitsu.com>	<20151220023712.GT20997@ZenIV.linux.org.uk>	<567616D6.6060202@cn.fujitsu.com>	<87fuyx1mfn.fsf@x220.int.ebiederm.org>	<567798EC.1040304@cn.fujitsu.com>	<87twnbzcz8.fsf@x220.int.ebiederm.org>	<567A1120.3070204@cn.fujitsu.com> <8760zpxgte.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760zpxgte.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 12/24/2015 12:36 AM, Eric W. Biederman wrote:
> Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> writes:
[...]

Hi Eric,
	Happy new year and sorry for the late reply.
>
> Given the other constraints on an implementation the pid namespace looks
> by far the one best suited to host such a sysctl if it is possible to
> implement safely.

So you think it's better to isolate the core_pattern in pid_namespace,
am I right?

But, core_file_path and user_mode_helper_path in core_pattern are much
more related with mnt_namespace IMO.

Could you help to explain it more?

Thanx
Yang
>
> Eric
>
>
> .
>


