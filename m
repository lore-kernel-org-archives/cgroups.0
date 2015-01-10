From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET RFC block/for-next] writeback: cgroup writeback support
Date: Sat, 10 Jan 2015 11:05:15 -0500
Message-ID: <20150110160515.GB25319@htj.dyndns.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
 <20150106214426.GA24106@htj.dyndns.org>
 <20150107234532.GD25000@dastard>
 <20150109212336.GB2785@htj.dyndns.org>
 <20150110003819.GP31508@dastard>
 <20150110155653.GA25319@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2sm+WVmVcAScVYdoxdIWMabvvHGQYvEp+xho8vqpQq0=;
        b=E0qtwGfyvm/eVrHAW1xqBGXc0pPR5mzna1EQVcRxiaGtjriPJYgfuySXu0wwWnYi28
         Al4U4+b5wpk92EYJ9qOtoKwGKo6ICXIiBZs5dXxUFlYiZa+7ibOssYlE+818ZT56pMqN
         ytmNXGLnMNwD/GoFgVbnE5FJMXd45hDf9JMKZzUNmj6kO9sjs0XeUvq28MHLxyMauhPf
         s+dI8/axroY7PHNOadJrUGKx7PkgxwTZiFKzwDZz5Bu7Z45Be19vQLQOdrnzX0r2sztg
         OPsXo46tNxyxtN94LD3INv0AUCn9iL1w75Q6wglxy+t4tBuFICrVhgZ1XcfWZogTmLf4
         sflQ==
Content-Disposition: inline
In-Reply-To: <20150110155653.GA25319@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com

On Sat, Jan 10, 2015 at 10:56:53AM -0500, Tejun Heo wrote:
...
> backpressure propagation.  If you start mixing pages from different
> cgroups in a single bio, the only options for handling it from the
> lower layer is either splitting it into two separate requests and
> finish the bio only on completion of both or choosing one victim
> cgroup, essentially arbitrarily, both of which can lead to gross
> priority inversion in many circumstances.

Another aspect to consider here is that cfq-iosched doesn't even issue
IOs from different cgroups at the same time.  It schedules time slices
for different cgroups and at any given time only issues a stream of
IOs from a single cgroup.  This is mainly because it's impossible to
determine how much time the target device to process a specific IO
request, especially when it's a write.  The only way we can
approxmiate the cost with an acceptable level of accuracy is bunching
multiple IOs up and then measure the time to finish them in groups so
that the the deviations can be spread across multiple requests.  This
means that we can't issue IOs belonging to different cgroups at the
same time because we can't account for the divisions of cost for the
different cgroups.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
