From: Waiman Long <longman@redhat.com>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Tue, 6 Sep 2022 16:01:06 -0400
Message-ID: <02b8e7b3-941d-8bb9-cd0e-992738893ba3@redhat.com>
References: <88b2910181bda955ac46011b695c53f7da39ac47.camel@mediatek.com>
 <b605c3ec-94ab-a55f-5825-9b370d77ecf3@quicinc.com>
 <203d4614c1b2a498a240ace287156e9f401d5395.camel@mediatek.com>
 <YxeR0RoiTdm8sWCJ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=3EYAXh2z9lItNpM5nRfvk6Y9qAIa9BdVNx4Y1+8vtpU=; b=kTOhVG8zafU8G3
	TqXYiwTSyDLDYYW51NVM+KeN2IKGRr18DYhiOqePfUya0q2XhASOTd8sBkxYQZ0z5F6rotgxttYkQ
	ABKNSal26XbjQCt5MLdLiPO78KqPPY5zjI8TTwJFv1G0Y9Z0U9bPwUoZGKAzAUWwjl9D5rVq+72Km
	dn3cO6VPyHWgkpb085JnYc2HHvTM6kxAkEF1EOg5OakvGGzBXT3RZaMOELuJHM0shEW4eKx9B8vmz
	9DTPSXhVad+/lc1iH/OZQgC2vnVq/LUFbGsO7xmANhOGz2ME8q6eYmbBnvUnPFZBblN5BYwKmvTnO
	X7uFPw0HYKbcDlKTKxiA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662494474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kt6CEFAueWK0HKI9UIQ8H4IFzaooggSyLPO1T4AFfQ=;
	b=dVL8SxPSOVrDQ9dbXWZFibqo8ImcRIM/NzedLI2Bi78Gu9gYCm1llHYHmwlsbNbl89V697
	53vwwS3h7sGwXrFS+tajeFf9gcplvSq1W2kxL1Sk8MuD+OWi+R2IDjImgTpxYEpWEIBj90
	kmaZRBQmMlCSK+87AHhdGoZM1TzBxQQ=
Content-Language: en-US
In-Reply-To: <YxeR0RoiTdm8sWCJ@slm.duckdns.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Jing-Ting Wu <jing-ting.wu@mediatek.com>
Cc: Mukesh Ojha <quic_mojha@quicinc.com>, Peter Zijlstra <peterz@infradead.org>, Valentin Schneider <vschneid@redhat.com>, wsd_upstream@mediatek.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Jonathan.JMChen@mediatek.com, "chris.redpath@arm.com" <chris.redpath@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Vincent Donnefort <vdonnefort@gmail.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Christian Brauner <brauner@kernel.org>, cgroups@vger.kernel.org, lixiong.liu@mediatek.com, wenju.xu@mediatek.com

On 9/6/22 14:30, Tejun Heo wrote:
> Hello,
>
> (cc'ing Waiman in case he has a better idea)
>
> On Mon, Sep 05, 2022 at 04:22:29PM +0800, Jing-Ting Wu wrote:
>> https://lore.kernel.org/lkml/YvrWaml3F+x9Dk+T@slm.duckdns.org/ is for
>> fix cgroup_threadgroup_rwsem <-> cpus_read_lock() deadlock.
>> But this issue is cgroup_threadgroup_rwsem <-> cpuset_rwsem deadlock.
> If I'm understanding what you're writing correctly, this isn't a deadlock.
> The cpuset_hotplug_workfn simply isn't being woken up while holding
> cpuset_rwsem and others are just waiting for that lock to be released.

I believe it is probably a bug in the scheduler core code. 
__set_cpus_allowed_ptr_locked() calls affine_move_task() to move to a 
random cpu within the new set allowable CPUs. However, if migration is 
disabled, it shouldn't call affine_move_task() at all. Instead, I would 
suggest that if the current cpu is within the new allowable cpus, it 
should just skip doing affine_move_task(). Otherwise, it should fail 
__set_cpus_allowed_ptr_locked().

My 2 cents.

Cheers,
Longman
