From: Victor Porton <porton@narod.ru>
Subject: Re: Notifying on empty cgroup
Date: Wed, 15 Jan 2014 16:11:40 +0200
Message-ID: <409331389795100@web18j.yandex.ru>
References: <135711389759165@web22h.yandex.ru> <20140115135930.GK8782@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narod.ru; s=mail;
	t=1389795101; bh=OdC/ryNcxW8g1qpuw+DR+boYams7TIwo8WMdTYzl6PI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=X/TsTfLJ6sGpotXHAyeFx4N2Zq+ld2UNvXkjacoiDoyO+he1nMafMC/0VhRzLKKsP
	 O6Yn5XuIANVdFdwb56fqeCDQOdkqgzQtzdRMN+WGtWRvpuv1XUNtq8ZSrknqMJlKm6
	 VyoEfWJtWjtAJRWef0NmltMmU4W+6Fx2QzRAbBDQ=
In-Reply-To: <20140115135930.GK8782@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>

15.01.2014, 15:59, "Michal Hocko" <mhocko@suse.cz>:
> [CCing cgroups mailing list]
> On Wed 15-01-14 06:12:45, Victor Porton wrote:
>
>> =9AI want to write software which needs to receive a signal when the=
 cgroup
>> =9Acreated by it becomes empty. (After this the empty cgroup should =
be deleted
>> =9Ajust not to clutter the memory.)
>>
>> =9AIf the kernel does not support such notifications, it should be i=
mproved.
>> =9AThis functionality is crucial for some kinds of software.
>>
>> =9AThere is /sys/fs/cgroup/systemd/release_agent but I don't underst=
and how to
>> =9Ause it. I don't understand why we would need it at all.
>
> "1.4 What does notify_on_release do ?" in
> Documentation/cgroups/cgroups.txt the kernel source doesn't help?

I've read it. I understand what it does. I don't understand how to use =
it in practice nor why it is done this way.

>> =9AStarting a binary on emptying a cgroup with the purpose to notify=
 an other
>> =9Abinary looks like a big overkill.
>
> the binary can do rmdir which is what you want, no?

I suppose a base package should do that, not my specific software. Do I=
 understand right?

>> =9AAlso my program should work in userspace without the need to use
>> =9Arelease_agent which can be accessed only by root.
>
> The release_agent is global for all groups so the program doesn't hav=
e
> to care.

Again: What MY program should do?

>> =9ANote that my work is related with sandboxing software (running a =
program in
>> =9Aclosed environment, so that it would be unable for example to rem=
ove user's
>> =9Afiles).
>>
>> =9ASee also
>> =9Ahttp://portonsoft.wordpress.com/2014/01/11/toward-robust-linux-sa=
ndbox/
>>
>> =9A--
>> =9AVictor Porton - http://portonvictor.org
>> =9A--
>> =9ATo unsubscribe from this list: send the line "unsubscribe linux-k=
ernel" in
>> =9Athe body of a message to majordomo@vger.kernel.org
>> =9AMore majordomo info at =9Ahttp://vger.kernel.org/majordomo-info.h=
tml
>> =9APlease read the FAQ at =9Ahttp://www.tux.org/lkml/
>
> --
> Michal Hocko
> SUSE Labs

--=20
Victor Porton - http://portonvictor.org
