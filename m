From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v3
Date: Mon, 17 Jul 2017 10:51:19 -0400
Message-ID: <20170717145119.GG3519177@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <f6cdb0b7-4c73-ff4c-6693-fd1cb17015c0@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HuCs3Hk+Ja/je64vcT1DwKXEZbxfmW1Bu5dH0YvVDWk=;
        b=c0NH5C/HEYOdeG6hvEVJMgFuuQFjrHfmCp27/2WEHcXGcKbMT9hkoaNQTRYVvHzkuT
         Y2NnPob3EtgCSFrNiURbD17ZMOtlaDrjPL/wGeQcN5tuanN5v2fbb0srolDMvvVbkpcF
         sGYdgcFuFkBA8qvDAiFPlLKHzuqOYSaTDNsO4pfYTYvL6Suybu+tbR5A3iUonbKFn/EK
         2DGo5kX8b5dOuaVbkFSgfpdSBr5EGeoHLlD72yWfuhLD4bi8JOeMjtPQnq/BsJSEWXKl
         YXhOfIm+/H4UWg9mh2p7uy1lq3Bl4RKnPueTMhaNKGJ41G52CP4pTVqL0JoWpiAB/smf
         EAQg==
Content-Disposition: inline
In-Reply-To: <f6cdb0b7-4c73-ff4c-6693-fd1cb17015c0@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Mon, Jul 17, 2017 at 10:48:44AM -0400, Waiman Long wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v3
> 
> Your new patches don't seem to be pushed to your git tree yet. I
> couldn't find them there.

Oops, pushed out now.

Thanks.

-- 
tejun
