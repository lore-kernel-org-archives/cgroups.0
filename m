From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Wed, 17 Feb 2016 18:02:31 -0500
Message-ID: <20160217230231.GC6479@mtj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PL4ikS/grvS5gHTri/mruFvnKtcs9LISMCxXrKXRRn0=;
        b=hwzGKeNVb66j8JeuIWFj+4z+zSwyTI+xvS5/4GedRtoBSdWb1BW04UhEyit8suAgTt
         sF64xrYMOd+S4RNYvaFAhzarfkZU+c8djMgiRzJ1oDvbU/2gXcTZraar9F864+0PvKVV
         FScfGOhKivt1SwjPSYsnhO+zASLgimqSO4N37zWrXcD9g738rvGeRgFD46O9D1l6ItL6
         8FUnr89UkCQqpj+nRuPRg+MgbQZiPmyw65O8TntYoM9B/OAjQNiRAr0aEGO202mCZb3a
         tOaO7K0KsLyXeU0FrbdD239Mh02eibsr7IFdtrmNU/1b4Lxww8I/EfSlx6W0mNYuvUlV
         qomg==
Content-Disposition: inline
In-Reply-To: <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On Wed, Feb 17, 2016 at 02:41:25PM -0800, Tahsin Erdogan wrote:
> With this patch, I am starting to have issues running fsck immediately
> after umount.
> 
> *** fsck.ext4 output ***
> fsck from util-linux-ng 2.17.2
> e2fsck 1.42.12-gg3 (9-Sep-2014)
> Warning!  /dev/sdb3 is in use.
> Pass 1: Checking inodes, blocks, and sizes
> Deleted inode 62346243 has zero dtime.  Fix? no

Yeah, that'd be one of the side effects.  Will think more about it.
Jan, do you know why we have both s_active and the rwsem at this
point?  I can't tell why both are needed.

Thanks.

-- 
tejun
