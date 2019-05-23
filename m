From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: [PATCH v2 0/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Thu, 23 May 2019 13:44:46 -0500
Message-ID: <1558637087-20283-1-git-send-email-chiluk+linux@indeed.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yNILfyJChXA1qHX1Kqi1owLnUHep4ERKIkS79Wu1+tk=;
        b=ytyrCd/qOMiw0SMCH3uGeCH96UCKXfeNngBh+3fqTLyrvfr3w1CggUfgpYbxePvNdH
         mgBFPc9L9iqibPjumTk2GvTbWndammyucmWOw7SoENj+v2wcyYufN6wiTU612eG5yOFW
         L3WLFb7W/s9PKX9oom+IMNnX0YkzBTk+WZOnc=
In-Reply-To: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

Changelog v2
    - Fixed some checkpatch errors in the commit message.
