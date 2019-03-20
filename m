From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 4/7] psi: split update_stats into parts
Date: Wed, 20 Mar 2019 16:59:15 -0400
Message-ID: <20190320205915.GC19382@cmpxchg.org>
References: <20190319235619.260832-1-surenb@google.com>
 <20190319235619.260832-5-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dlgp2MdnsREd+nc4jSTOXVYFicF0JfUh7ydGu+tAmLg=;
        b=YFtoHdtQVZ9UvOqKhzJE/FYr9snrw4U6DTalkvSVji/qTo+Xewly3DaO54P3LXZ00N
         DCkyCPgHLU6+6peHoQGzFBSNMQ1D4WoC/K1tOo2p1k1QMllPOcX8vSVwg9ot+itOWnBs
         MFSu8ao8DVt34JuqAB4FTA2K8AzQbqj4tAMwjc16oPP9nyN3gqyDdycq/R2eLmQM1eCm
         CnCh36QBmpaU1h3lP7b4Ro7nEi9FuAIhuZCMDi2tUulho3iic+3sgGjB6yCKgjn0ex4S
         yCIqdP/J6iBjKtO2cK0DNc80TYtqEbIYBWvnXXYaQEyWh5PpPvvGz5YB8bpekTOlJPAr
         wsjw==
Content-Disposition: inline
In-Reply-To: <20190319235619.260832-5-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Tue, Mar 19, 2019 at 04:56:16PM -0700, Suren Baghdasaryan wrote:
> Split update_stats into collect_percpu_times and update_averages for
> collect_percpu_times to be reused later inside psi monitor.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
