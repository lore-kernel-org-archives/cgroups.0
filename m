From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 09:52:22 -0800
Message-ID: <20190130175222.GA50184@devbig004.ftw2.facebook.com>
References: <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz>
 <20190129145240.GX50184@devbig004.ftw2.facebook.com>
 <20190130165058.GA18811@dhcp22.suse.cz>
 <20190130170658.GY50184@devbig004.ftw2.facebook.com>
 <20190130174117.GC18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nqKoowBhVNotvsktwsU7UZYX3ZVWVurI0845PhIUGvE=;
        b=dOHMTovASZbHyzLMlsR1yiUz4PRvp4/poseV7ogwNMHv3/be5mx/yokv2EEwmfpd7T
         FK/vMQcx4rU01+ILFFvVnmT19udKPJH0GBaWw3rzZ/59IhlxxwYzXEjCGPx8j4W0slD5
         8mjqVJfR0n0h5oQFJ8Bj6WXWQd8hUGp1Pslh3smiu/WkeKL2wL8B4c5hxR30r+V9KW61
         kO99vj4we+fQpeuEG3HgawSzwpSgLCBWejrCgd9CsRY1nniS3gTUf6b1YaunN5R0cS88
         +9Gud7dyuD1S4gO7Z1GHVUnIdEahBP1feMONom808xwfS7aH2Rws+RibtI316+umNGgI
         NpIA==
Content-Disposition: inline
In-Reply-To: <20190130174117.GC18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed, Jan 30, 2019 at 06:41:17PM +0100, Michal Hocko wrote:
> But we are discussing the file name effectively. I do not see a long
> term maintenance burden. Confusing? Probably yes but that is were the

Cost on user side.

> documentation would be helpful.

which is an a lot worse option with way higher total cost.

If you aren't against making it a mount option (and you shouldn't),
I think that'd be the best use of time for both of us.

Thanks.

-- 
tejun
