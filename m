From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Mon, 22 Sep 2014 12:44:51 +0800
Message-ID: <541FA943.5070009@huawei.com>
References: <541F9C96.10705@huawei.com> <20140922040214.GE23583@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140922040214.GE23583@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, keescook@chromium.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

On 2014/9/22 12:02, Tejun Heo wrote:
> On Mon, Sep 22, 2014 at 11:50:46AM +0800, Zefan Li wrote:
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>
>> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
>> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
>> because it is used as bit number. Redefine it as decimal bit number.
> 
> It's also changing the bit position, which is fine but should be
> mentioned in the description.
> 

I've resent the patch with changelog updated.
