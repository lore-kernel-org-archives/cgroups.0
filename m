From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/5] fs: kernfs: add poll file operation
Date: Fri, 11 Jan 2019 07:25:56 +0100
Message-ID: <20190111062556.GA348@kroah.com>
References: <20190110220718.261134-1-surenb@google.com>
 <20190110220718.261134-2-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547187960;
        bh=BZq7W/mq1WwQjUnjQg0GbBzDfJE6SRMC+B/4SIJJyp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r75j1oTmrYnrP/ugPnHC8BYZBdC6mDZd+XbCGlhDWXLxdXiBhVQRAUcgqw0iW/wI1
         XW9+PvpL2qI1PcVGWovg1MDrQP7TV1aZz5XJGp8QGJnQ//7U0Fv7NraWhNiGLxSP8t
         i8ojOQ1l/ZeBxTcuGvsfHjIGvEAAvI89ftxfPeHs=
Content-Disposition: inline
In-Reply-To: <20190110220718.261134-2-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Thu, Jan 10, 2019 at 02:07:14PM -0800, Suren Baghdasaryan wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> Kernfs has a standardized poll/notification mechanism for waking all
> pollers on all fds when a filesystem node changes. To allow polling
> for custom events, add a .poll callback that can override the default.
> 
> This is in preparation for pollable cgroup pressure files which have
> per-fd trigger configurations.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
