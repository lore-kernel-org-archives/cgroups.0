From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 5/7] psi: track changed states
Date: Wed, 20 Mar 2019 17:01:15 -0400
Message-ID: <20190320210115.GD19382@cmpxchg.org>
References: <20190319235619.260832-1-surenb@google.com>
 <20190319235619.260832-6-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ac3c8BuwXRGufN3K90gjwkHmlf5WusrlHW6NBm1q4lU=;
        b=JEjXZibp3H4f5ucHf9/nYNdp/ytl0tGHWy0AKX8AmsOYBRlU8V7e7ASVsOt5LncbG1
         gCS3JBKOn47BLQ8g8YjIgv5iVaKorzkc91V8QDkcVsYe9/uFey0bvFZJ40zD0zOsl8II
         nHTxk66AWJwMWj4oEKBm1cbfvp6BYEg7JuMVewxzaYlEdBuWcOECG93P/lHKqFr/4AtI
         Ay0134rkQc9XtvkOKQ5mUy2sa9+TvRSVaXpfbxTCCpsuq4KZKEtKZF+CElW2vAYDxjNZ
         iH6/4zmve2aF6+bRlPsYN4X24H06xqEBtv9npU1i8LLPi3xQMpqTA2LPRN+hWfZwilZn
         FBVg==
Content-Disposition: inline
In-Reply-To: <20190319235619.260832-6-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Tue, Mar 19, 2019 at 04:56:17PM -0700, Suren Baghdasaryan wrote:
> Introduce changed_states parameter into collect_percpu_times to track
> the states changed since the last update.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

This will be needed to detect whether polled states activated in the
monitor patch.
