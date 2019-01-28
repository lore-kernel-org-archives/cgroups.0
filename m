From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 4/5] psi: rename psi fields in preparation for psi
 trigger addition
Date: Mon, 28 Jan 2019 16:23:42 -0500
Message-ID: <20190128212342.GC1416@cmpxchg.org>
References: <20190124211518.244221-1-surenb@google.com>
 <20190124211518.244221-5-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W3oY1xqZBvb5uVdN7aj7A+kp0VAxPGPd9sCt8NgdAbo=;
        b=oqCrtSNo/UoV97OKjZDNJhAd+dZJsc6m2M2jTE79zkINKeitFARxb4Btk8w5wssq7B
         h+qJkgT8Wh5LQornKlqF2y08DevoQTqEGNwy2CWiUjGkRrVvVJfmZ3SrSvhz4AAe9rjf
         xHaOrje31Y2ilUukiJ5d/tYwJbwtfrHeychlWKqsWF5VNa3L9VW5lrOIZJsq4uEhSfCf
         tn2PJXCMjbQDTaDl4HdcjgJG0wAEarpQG6+PSpy/edY/weTfjIP5hvaTy54lHvMxq8Xv
         VF45QjoZG8eyKX/PV5Tl70U01SXO5/FUtnaJFguMeHIHI4f/m63YIb3dKWV8O4AVFqwz
         02Sw==
Content-Disposition: inline
In-Reply-To: <20190124211518.244221-5-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Thu, Jan 24, 2019 at 01:15:17PM -0800, Suren Baghdasaryan wrote:
> Renaming psi_group structure member fields used for calculating psi
> totals and averages for clear distinction between them and trigger-related
> fields that will be added next.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
