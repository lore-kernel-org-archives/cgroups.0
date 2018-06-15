From: Tejun Heo <tj@kernel.org>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 12:07:24 -0700
Message-ID: <20180615190724.GX1351649@devbig577.frc2.facebook.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
 <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
 <20180615154140.GV1351649@devbig577.frc2.facebook.com>
 <1d635d1d-6152-ecfc-d235-147ff1fe7c95@icdsoft.com>
 <20180615161647.GW1351649@devbig577.frc2.facebook.com>
 <6c2c9bfb-3175-b9ec-cf39-c9d4ebf654b2@icdsoft.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aLlAj4iPfNUfXXqcTzAK1dScCO4gTP4X+zVMnNbdWA0=;
        b=qwj6WqMLpNc0i7I/IJ0Olx7H/nG7GF7oGSzPv5n4kOw59ALSZWnsyZmtFMrfFwue2+
         4pIh9t/22UMS64jPhcRvsNZQOMkx2cojhYDvZUK/+rer+ZWUeWORhId3mBfxAWa4oK1M
         XCho0AjDI/5WpVg7MorWRjcolFJk8+Efanx9mrXZDu9jMiLU2RoiR9DVqgy5XWnWP7pr
         2Hwm2ycy6XorBUOoXU0mQphRdWyWjc0PvZd82gSzjgd0QBUpXJg9nB15uDJZheYGepAi
         Do1pkQB8o03Fe5c1V6GkBbfvhxfzOcHB1hwq0Me4LH4zAYz1/VvxeTPae8PHFXDyglyD
         Lfxg==
Content-Disposition: inline
In-Reply-To: <6c2c9bfb-3175-b9ec-cf39-c9d4ebf654b2@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Zahariev <famzah@icdsoft.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Ivan.

On Fri, Jun 15, 2018 at 08:40:02PM +0300, Ivan Zahariev wrote:
> The lazy pids accounting + modern fast CPUs makes the "pids.current"
> metric practically unusable for resource limiting in our case. For a
> test, when we started and ended one single process very quickly, we
> saw "pids.current" equal up to 185 (while the correct value at all
> time is either 0 or 1). If we want that a "cgroup" can spawn maximum
> 50 processes, we should use some high value like 300 for "pids.max",
> in order to compensate the pids uncharge lag (and this depends on
> the speed of the CPU and how busy the system is).

Yeah, that actually makes a lot of sense.  We can't keep everything
synchronous for obvious performance reasons but we definitely can wait
for RCU grace period before failing.  Forking might become a bit
slower while pids are draining but shouldn't fail and that shouldn't
incur any performance overhead in normal conditions when pids aren't
constrained.

Thanks.

-- 
tejun
