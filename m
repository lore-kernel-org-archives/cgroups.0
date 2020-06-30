From: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] doc: cgroup: add f2fs and xfs to supported list for
 writeback
Date: Tue, 30 Jun 2020 08:59:34 -0500
Message-ID: <59265a9d-ee0f-4432-3f86-00d076aeb8e8@sandeen.net>
References: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
 <20200630054217.GA27221@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200630054217.GA27221-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 6/30/20 12:42 AM, Christoph Hellwig wrote:
> On Mon, Jun 29, 2020 at 02:08:09PM -0500, Eric Sandeen wrote:
>> f2fs and xfs have both added support for cgroup writeback:
>>
>> 578c647 f2fs: implement cgroup writeback support
>> adfb5fb xfs: implement cgroup aware writeback
>>
>> so add them to the supported list in the docs.
>>
>> Signed-off-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>
>> TBH I wonder about the wisdom of having this detail in
>> the doc, as it apparently gets missed quite often ...
> 
> I'd rather remove the list of file systems.  It has no chance of
> staying uptodate.

Is there any way for a user to know whether a filesytem does or doesn't
support it, in practice?

Thanks,
-Eric
