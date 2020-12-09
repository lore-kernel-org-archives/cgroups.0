From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to
 finish on cpu online
Date: Tue, 08 Dec 2020 21:09:35 -0500
Message-ID: <87k0trvig0.fsf@oracle.com>
References: <20201203171431.256675-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TQkdG2HxofP7Gjx/2MbWPihewec5Qk/l1s4p7G1cXC8=;
 b=U9gwOjq7SmCbCgRImhl1TwXzuxOUUqCB0rMIJdegBcv9/Gzu+laCbtU2jTGUxx4tmpH4
 mNyfpxy3z+yi78IBboMbbYliZCv4lw8u1B5OZX4xN83a6LobhTnYThTFG/S8qL7rVcgx
 MAL5OtXa0n2n4fD2nkobJowekxaCoWc2abDld8DvitfkDcfrKCu0tCuSF17ebefEYn9k
 +43E16O5KWiZ7JrgzfXlBfgw1bDTwmrtz/I6mk66Stx/Z9oe3N3jvGsywGPBTqMEwKFx
 21a5WpWQwP3sEppwkJgVBptCcyDKtLxBX4s6ZoUmQs3Dnp6XDYjbfElMId5YhlVLHGoz Hw== 
In-Reply-To: <20201203171431.256675-1-aklimov@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: peterz@infradead.org, yury.norov@gmail.com, tglx@linutronix.de, jobaker@redhat.com, audralmitchel@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org, rafael@kernel.org, tj@kernel.org, lizefan@huawei.com, qais.yousef@arm.com, hannes@cmpxchg.org, klimov.linux@gmail.com

Alexey Klimov <aklimov@redhat.com> writes:
> I also in doubts if we need cpuset_wait_for_hotplug() in cpuhp_online_cpu_device()
> since an online uevent is sent there too.

We do need it there if we go with this fix.  Your reproducer hits the
same issue when it's changed to exercise smt/control instead of
cpuN/online.
