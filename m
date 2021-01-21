From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to
 finish on cpu online
Date: Wed, 20 Jan 2021 21:09:27 -0500
Message-ID: <87ft2voxbc.fsf@oracle.com>
References: <20201203171431.256675-1-aklimov@redhat.com>
 <20201207083827.GD3040@hirez.programming.kicks-ass.net>
 <87k0tritvq.fsf@oracle.com> <87im7yc2bu.fsf@oracle.com>
 <CAFBcO+_PoXhbq+p-2z=acCpboJtOewXkp-9-3=csafoAYuNFQw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OPs4WlA7uDKrhe4fwAyB9Djai7DI8qa4Dh093prfKPk=;
 b=UQQH58W2miH1vTQIrdFmQNMPRawJz2Zu/NPSWCZKzwD9740CW+srwUjKQ4uVdEMpkafI
 XHRtiknO7IN/vRLZqhDAMC2lIKkiJtI/QMmfzUIsny84das5ahFTJiFSmXc4mWhNHgWH
 foZbk9Pu02H5+Z/66//5HxrfMZLNor5DPoxsEwJn/OjwdxXudLYRxVMB3jj43rOrxW37
 2iGz4E13Tk4JEa++5TTpr6ahnGJyuAXBWSzF7+7nUrIFBEHjy+kaRNL/VZvvNQg5SluM
 jVCxo4gBDc7cl5HEcbYPXdLXCLliwg2Vje19RWLVJ7tXsmg62eAMg+vT66gGgj/NrEn0 CA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPs4WlA7uDKrhe4fwAyB9Djai7DI8qa4Dh093prfKPk=;
 b=F2R+ZCTWhzg+pssSAbeiAFcEgiIqkygKzugHWDtwTsAn5lGFDaNSXDEzihfMtywqfeL+TutLSEHzjSMjk72VJVTLi7J3xOz92996Ky9IOSZkxUafu44KZqRXMoaKeQ5YMm41jYfTsygMaDlgvPcnPNPtKYz3R9AzwMT6hyfgrHA=
In-Reply-To: <CAFBcO+_PoXhbq+p-2z=acCpboJtOewXkp-9-3=csafoAYuNFQw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yury.norov@gmail.com, tglx@linutronix.de, jobaker@redhat.com, audralmitchel@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org, rafael@kernel.org, tj@kernel.org, lizefan.x@bytedance.com, qais.yousef@arm.com, hannes@cmpxchg.org, Alexey Klimov <klimov.linux@gmail.com>

Alexey Klimov <aklimov@redhat.com> writes:
> Daniel, thank you for taking a look. I don't mind reviewing+testing
> another approach that you described.

Eh, I like yours better :)

>> Absent further discussion, Alexey, do you plan to post another version?
>
> I plan to update this patch and re-send in the next couple of days. It
> looks like it might be a series of two patches. Sorry for delays.

Not at all, this is just something I'm messing with when I have the
time.
