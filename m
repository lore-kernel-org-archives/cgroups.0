From: Chris Mason <clm@meta.com>
Subject: Re: move bio cgroup punting into btrfs
Date: Tue, 28 Mar 2023 17:18:43 -0400
Message-ID: <512eaacf-3ff6-f4f9-c856-a0e03c027501@meta.com>
References: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=EhPMp2qp9jjI1AQyh9X+OKpkYZAtozxBNWxVoOqwgbc=;
 b=PBolmj2cXkQHAty+kcK87WJQCfcWhmW4CZwtw9t0qS5TBF2uI/7UgBWQ22Ulocp5ONl/
 rRHHXgurzyS0ypvs9evEzcO05Pa4nGY5iCdz08936Q6EK9nrub+HgAEzi9NLoY3kbUzr
 I2qhbSH3heZoduVb70hGQqzuHYOlyoVN0TTmRcdeP7ekfy41zPO3/ChoQ++HNhnY3wdt
 g1raueq9nP9wBjJNeXn1k/LJPSR/ohwwLDw3g2wwLs3r/83k6WePHM0BgSzPkQbyfFXR
 75e6c8jmvyGPOjDQN3eaOdEKVpp/bA1TInnKovEqOnfw7ZrOQ6oHHTiExAhoTFjHudtG aQ== 
Content-Language: en-US
In-Reply-To: <20230327004954.728797-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

On 3/26/23 8:49 PM, Christoph Hellwig wrote:
> Hi all,
> 
> the current code to offload bio submission into a cgroup-specific helper
> thread when sent from the btrfs internal helper threads is a bit ugly.
> 
> This series moves it into btrfs with minimal interference in the core
> code.
> 
> I also wonder if the better way to handle this in the long would be to
> to allow multiple writeback threads per device and cgroup, which should
> remove the need for both the btrfs submission helper workqueue and the
> per-cgroup threads.

We tried a few different ways to solve this internally, and I'm not
against folding it back into btrfs but I'm kinda surprised that nobody
else needs it?

Is btrfs really the only place using worker threads to submit IO, or are
we just the only ones looking for the priority inversions w/resource
control in place?

-chris

