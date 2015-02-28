From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 11:57:06 -0500
Message-ID: <20150228165706.GS3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org>
 <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
 <20150227214904.GQ3964@htj.duckdns.org>
 <CAAAKZwsCc8BtFx58KMFpRTohU81oCBeGVOPGMJrjJt9q5upKfQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=e8y5118Pdf7oqoYXQ5FSVr2R2/vEAjLNfRhtdFYeViA=;
        b=JY62wbYzvKuhbnmGozxYmpgX9Zu2haUaj+Ygkb6KXLED6JwP3p1d/xbHYWDKFBYgbo
         F7vzLOifpDtnX7YyCNpodj53Hy2rrckrI5kToMTjKRbO3KaahUDuOZEKjFmo2De/l57w
         LOhPmOyzkuU2xpnOw25NbFHzzk4D4GGJ+K/nlABVARSb3deyZZvS3Ub0yQg/l6ym13Zu
         z7L+N39vdhmpzSRD76hPu57pqGhOvOR3xPXKcPTV3wftrOLGZTMazw2gKBIO8YgjrmqV
         pt+ab3D54ZJ7yZuAgEoorSaRitsinBJJiMxcJnG9NGDZlcka+M4cfdA6eFcF6SgFLyna
         VaFw==
Content-Disposition: inline
In-Reply-To: <CAAAKZwsCc8BtFx58KMFpRTohU81oCBeGVOPGMJrjJt9q5upKfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin@hockin.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, richard <richard@nod.at>, mingo <mingo@redhat.com>

On Sat, Feb 28, 2015 at 08:48:12AM -0800, Tim Hockin wrote:
> I am sorry that real-user problems are not perceived as substantial.  This
> was/is a real issue for us.  Being in limbo for years on end might not be a
> technical point, but I do think it matters, and that was my point.

It's a problem which is localized to you and caused by the specific
problems of your setup.  This isn't a wide-spread problem at all and
the world doesn't revolve around you.  If your setup is so messed up
as to require sticking to 16bit pids, handle that locally.  If
something at larger scale eases that handling, you get lucky.  If not,
it's *your* predicament to deal with.  The rest of the world doesn't
exist to wipe your ass.

-- 
tejun
