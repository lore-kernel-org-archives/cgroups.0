From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 02 Mar 2015 17:02:57 +0100
Message-ID: <1425312177.12094.15.camel@gmail.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	 <1424882288-2910-3-git-send-email-riel@redhat.com>
	 <54EEFE15.3010005@huawei.com>
	 <20150226121231.6fcba7e8@annuminas.surriel.com>
	 <20150302090933.GH21418@twins.programming.kicks-ass.net>
	 <1425300290.5863.17.camel@gmail.com>
	 <20150302152924.GD17694@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=SxSBhcpZe3ndsATyTEHbUV/bYvy5onLYUOLHNwStVxk=;
        b=J7oaUDBSw2T7aDuYtJWtjITrWHCkC+oBElxQjpkwoJaqTmpoRSr5kWPaWT3jBfy3PF
         Y5jeIshPq7wLx9umB+lE3OjLx6tV+JL54iMgOg0WdVHtSMph9zVxP7U2AtL6n429/JJ1
         v14BMZ4cMxrE+qZkk1DNFsrjGOvkHq1EBVCXLYf4HCWvQJajqtRKmhnzJ5E85Z/VXoqx
         HzeEzFBz4us/w18C0tEWZIUypurld0TrsytL5rVZ56eFSftugYDCE9jpuwLin/LL5aDz
         ZAr5Sp/ExdMOoaxzlC37vE+ywDEwxTjUpQw1Mkxy3SSigJ8cZLoRlwSNRSmFP06ckiSo
         E1oA==
In-Reply-To: <20150302152924.GD17694@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Zefan Li <lizefan@huawei.com>, linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org

On Mon, 2015-03-02 at 10:29 -0500, Tejun Heo wrote:
> On Mon, Mar 02, 2015 at 01:44:50PM +0100, Mike Galbraith wrote:
> > Hm, I'm now all system-disease-ified now (still hate the bloody thing),
> > and have no problem isolating cpus via cpusets, modulo workqueues
> > wanting a bat upside the head.
> 
> It shouldn't be difficult to teach workqueue pools to follow the same
> rules.  This matters only for the unbound ones anyway, right?

Well, those are the only ones we can do anything about.  Dirt simple
diddling of the workqueue default mask as sched domains are
added/removed should do it I think.  Automatically moving any existing
unbound worker away from isolated cores at the same time would be a
bonus, most important is that no new threads sneak in.

	-Mike
