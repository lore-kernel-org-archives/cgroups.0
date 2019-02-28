From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm, memcg: Handle cgroup_disable=memory when getting
 memcg protection
Date: Thu, 28 Feb 2019 12:51:41 +0000
Message-ID: <20190228125141.GA7365@chrisdown.name>
References: <20190201045711.GA18302@chrisdown.name>
 <20190201071203.GD11599@dhcp22.suse.cz>
 <20190201074809.GF11599@dhcp22.suse.cz>
 <20190226152958.726b921f0cb03ccc50144539@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9abm0vdzy1u8k6t9ZPdWfEHMFX/OS1Bdc2ERO6x3ga0=;
        b=QjwzuLxDrl+HPKlwdKfODyAY2mBGwVvTaW9CLwhP32n2Lvx/8GicnuinoOZWPO8NJP
         qsjsDgtvcl/0BePwDn7LlW7Vyc1CI604eY1Jt6o6HWr2VcYo2muKLPsjM/ljuwaBxvbQ
         bOpUhPejtlwVVJHXuL2oF7YeBoiy+i3VrcLRg=
Content-Disposition: inline
In-Reply-To: <20190226152958.726b921f0cb03ccc50144539@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Andrew Morton writes:
>Things settled down.  Here's the rolled-up patch.  Please review?

Looks correct to me as patch author, thanks!
