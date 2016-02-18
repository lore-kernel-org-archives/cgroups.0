From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Thu, 18 Feb 2016 12:12:40 +0200
Message-ID: <56C59918.70505@kyup.com>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160216182457.GO3741-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>



On 02/16/2016 08:24 PM, Tejun Heo wrote:
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-and-tested-by: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Link: http://lkml.kernel.org/g/CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> Fixes: d10c80955265 ("writeback: implement foreign cgroup inode bdi_writeback switching")
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org #v4.5+


Why is this tagged for 4.5+ since the commit in question was merged in 4.2?
