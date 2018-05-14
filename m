From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 0/7] psi: pressure stall information for CPU, memory,
 and IO
Date: Mon, 14 May 2018 15:39:33 +0000
Message-ID: <010001635f4e8be9-94e7be7a-e75c-438c-bffb-5b56301c4c55-000000@email.amazonses.com>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ug7nbtf4gccmlpwj322ax3p6ow6yfsug; d=amazonses.com; t=1526312373;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=D3CsZ/Vj+DM10CeeElDfPBydAdL/Qxd58+M40Ago1b4=;
        b=JwESVGB0zFrNjHf5A3botHZ6z34d1hAZ+ajs0dwb44r9JlUBLPE7qGlg7IVCddmP
        YOnCwe9M/aT+p/TleM31WsEyB3obooPUw4Rw4hEOttxprjeWtAvW984/meN07Dg8Ztm
        E0d8RXxNSXled+4wRBa1bZaQ46SxzyLPYCgRZEEU=
In-Reply-To: <20180507210135.1823-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, 7 May 2018, Johannes Weiner wrote:

> What to make of this number? If CPU utilization is at 100% and CPU
> pressure is 0, it means the system is perfectly utilized, with one
> runnable thread per CPU and nobody waiting. At two or more runnable
> tasks per CPU, the system is 100% overcommitted and the pressure
> average will indicate as much. From a utilization perspective this is
> a great state of course: no CPU cycles are being wasted, even when 50%
> of the threads were to go idle (and most workloads do vary). From the
> perspective of the individual job it's not great, however, and they
> might do better with more resources. Depending on what your priority
> is, an elevated "some" number may or may not require action.

This looks awfully similar to loadavg. Problem is that loadavg gets
screwed up by tasks blocked waiting for I/O. Isnt there some way to fix
loadavg instead?

