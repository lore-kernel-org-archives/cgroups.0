From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Wed, 18 Jan 2012 22:28:42 +0100
Message-ID: <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
References: <4F13DA90.2000603@cn.fujitsu.com> <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=+k7H4FCoJHTT7xkaw3CHyyAJ5Ehq4flYKeZm9ssB3Us=;
        b=gDZ5dGRIUHggisgqu9WTM+GLnhMzfKahFFRYPG5WNzcfbhwEjGWcAGo0ypWTmrAG/j
         vL7LMZDQrd3wyHsLBy/SHfGxDTW89YCd1UPhez39HBsmazP2WKzg3peTRkQkxNGbZcqL
         ruomzL1XJMI2f381UmYLPk351/1IQDiTMKijY=
In-Reply-To: <20120117175322.GC6762-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

On Tue, Jan 17, 2012 at 18:53, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

>> > The key idea is that this would allow attaching runtime meta infor=
mation
>> > to cgroups and everything they model (services, apps, vms), that d=
oesn't
>> > need any complex userspace infrastructure, has good access control
>> > (i.e. because the file system enforces that anyway, and there's th=
e
>> > "trusted." xattr namespace), notifications (inotify), and can easi=
ly be
>> > shared among applications.

> Ummm... I don't feel too good about this. =C2=A0Why can't those extra
> information be kept somewhere else? =C2=A0Overloading cgroupfs as sto=
rage
> for essentially opaque userland information doesn't seem like a good
> idea to me.

A bit of the background:

The /sys/fs/cgroup/systemd/ hierarchy represents something like a
first class kernel-related system object, which we call an
'application' or 'service' in userspace. Every 'service' or
'application' has zero, one or many processes, and has some high-level
metadata attached.

The general idea, not specifcally related to cgroups, is to try as
hard as possible to stick metadata about objects to the objects
themselves. It's a bit like the difference of lock files vs. locks
attached to a process. In the later case, if the process dies, the
lock is automatically cleaned up, in the former, we have a stale file.

The idea with the cgroup fs xattrs was to be able to attach some
general useful attributes to the 'service container' itself, instead
of keeping them in the memory of the managing process or store them on
disk which can get out-of-sync much easier.

Kay
