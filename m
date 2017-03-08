From: Tejun Heo <tj@kernel.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Wed, 8 Mar 2017 13:59:47 -0500
Message-ID: <20170308185947.GA9976@htj.duckdns.org>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
 <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
 <20170307194134.GE31179@htj.duckdns.org>
 <9ee62e45-6645-454b-11b5-85be746bc81a@samsung.com>
 <20170307204825.GH31179@htj.duckdns.org>
 <50e07c29-295a-62fd-e0ad-7e52d5b55c7d@samsung.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=65OXJWvQkjiZ8+yXrIUDuflwf3CC4ttX9b6aa4V6kMA=;
        b=BFI6te8hM86ltoIL/jAnwRjoN5yGRBSdXuD7OMYAP8GwtcHJ7od4cZDvqlHvHaciA2
         AEwBkhdwm44HweKCJ+MJ+Yu4eM6lMu6g9dFwAIRY0HXnH82SA13AHuiElKnA/iAMdXTu
         FLYZRrR+ezxh/vClnPf+eZduuispF/AMICqATjm9G4IzWouxGHgvTfokWV+USKq7sUI1
         a6+oFnoqYif+NjDuxEyntLG8slcBC19ORc90X+Icenvp6yINhf++PhjP6aG/EuRxL4eH
         Toq7wSXG3UQ79YaaTBIKPMlF55eGJRw3e6ux5kGX7q1RxGsBW7wykqH6wBu7/JsXHcvP
         WXpg==
Content-Disposition: inline
In-Reply-To: <50e07c29-295a-62fd-e0ad-7e52d5b55c7d@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>, linux-kernel@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, cgroups@vger.kernel.org

On Wed, Mar 08, 2017 at 10:52:18AM +0100, Krzysztof Opasiak wrote:
> Well detecting failures of open is not enough and it has couple of problems:
> 
> 1) open(2) is not the only syscall which creates fd. In addition to other
> syscalls like socket(2), dup(2), some ioctl() on drivers (for example video)
> also creates fds. I'm not sure if we have any other mechanism than grep
> through kernel source to find out which ioctl() creates fd or and which not.
> 
> 2) As far as I know (I'm not a bpf specialist so please correct me if I'm
> wrong), with bpf we are able only to detect such events but we are unable to
> prevent them from getting to caller. It means that service will know that it
> run out of fds and will need to handle this properly. If there is a bug in
> this error path service may crash.
> What we would like to get is just a notification to external process that
> some limit has been reached without returning error to service itself.
> 
> 3) Theoretically we could do this using bpf or syscall auditing and count
> fds for each userspace process or check /proc/<PID> after each notification
> but it's getting very heavy for production environment.

We simply can't design the kernel to accomodate bandaid workarounds
for grossly misbehaving applications.  If you can find something which
can solve the problem using wider scope tools like bpf, seccomp, and
what not, great.  If not, too bad, but we can't burdern everyone else
with workarounds for the extremely specific and contrived issues that
you're seeing.

Thanks.

-- 
tejun
