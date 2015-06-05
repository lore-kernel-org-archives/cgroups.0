From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v11 7/7] cgroup: implement the PIDs subsystem
Date: Sat, 6 Jun 2015 06:05:30 +1000
Message-ID: <CAOviyajgOteux4dgJtQHP1GEkqv_r2+1Qkt2kgXExJop-jBm0g@mail.gmail.com>
References: <1431749621-30451-1-git-send-email-cyphar@cyphar.com>
	<1431749621-30451-8-git-send-email-cyphar@cyphar.com>
	<CAOviyaji+nEt53PSnyyX_LnWw5FE2p9AbdZrYz6eH2xcWuZCNw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOviyaji+nEt53PSnyyX_LnWw5FE2p9AbdZrYz6eH2xcWuZCNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

>                 err = pids_try_charge(pids, 1);
>                 if (err)
>                         goto out_fail;
Disregard this and the revert code. This was from me testing making
attach obey the set limit (which isn't going to in to the patchset).

--
Aleksa Sarai (cyphar)
www.cyphar.com
