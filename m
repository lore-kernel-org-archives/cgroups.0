From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH cgroup/for-4.21 2/2] cgroup: Add .__DEBUG__. prefix to
 debug file names
Date: Tue, 20 Nov 2018 13:46:35 +0100
Message-ID: <20181120124635.GM2131@hirez.programming.kicks-ass.net>
References: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
 <20181113201637.GO2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zx1BtPNRZGi9NtmTbPk5pQ+/mly0RsfUg6rO46cLT2o=; b=bX3yUM6OeXTXWhOmEroySGTMw
        vO1fT/PwJzc3SOQmLBbKy5K5aDG4CY1lkGtOfV+LS85w1yorxguHGS44fMjPPaZkOLbqow+UKhp/g
        pcGFFKo6c68E3vedOrKlggDUVPjh5xbu4DUUzLKXkytP6x5gR7ZrGrElMwyK3JnRTbNzajKxUMIm3
        pU9mLeL9Vk17FXQ5aXmcUNh5cpaWngCTK2zrwL7Gj2p+L9whp8BNDGjuPLIP9BADDg5E1JDG03PtB
        YXeoFdH1zFHzoQDdytQ95btxTiK4hf8Ur0DgLG9VqP3YGyPimE3PSJ/mrvkoKc04OBzzpuj5nvoPV
    
Content-Disposition: inline
In-Reply-To: <20181113201637.GO2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 13, 2018 at 12:16:37PM -0800, Tejun Heo wrote:
> From c1bbd933e5fae83f96acd3f748bb01a0300b315d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 13 Nov 2018 12:06:41 -0800
> 
> Clearly mark the debug files and hide them by default by prefixing
> ".__DEBUG__.".

ACK
