From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Wed, 29 Jul 2020 11:06:08 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2007291105570.4649@eggly.anvils>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <49d4f3bf-ccce-3c97-3a4c-f5cefe2d623a@linux.alibaba.com> <c00ac587-7f69-768a-84ea-53cbf7469ae9@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xJ2kJUaxCqHeFy3eTq7CnXVFURN/g/y8EYUBnKoxbLI=;
        b=Hh5+vEIQvFG8XKYfsn89W1ELEJAteSfSsR7+QmXXZZUAzVy+xvS+g5+YDaaAxrwJ3a
         Ss2XCpv7ku+uVEzhYEqB2q0gAvlwBKp5Pbe311njOHtO5UPoO6Mm2kpPHXLTBYCMwgB6
         05ODjedRN4Wbenc8RzTyzY95fTzbyOdbfmqkWB+/aPn4ARt0yzYImktzJhkK/aAGmbpY
         764Fg81c3gaPBkwzniuvZW3wcT9iWOSntfe75hQK3+oVNT4qOJOFRptI1kJPN1xhHbji
         kjTfGb3pTLdyFPdFooF13n+cVrfdNksjASH9Snfkf+BcLMoo6xgg640CAYbDxCA7kvq3
         VJ0w==
In-Reply-To: <c00ac587-7f69-768a-84ea-53cbf7469ae9@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com

On Wed, 29 Jul 2020, Alex Shi wrote:
> 
> Is there any comments or suggestion for this patchset?
> Any hints will be very appreciated.

Alex: it is now v5.8-rc7, obviously too late for this patchset to make
v5.9, so I'm currently concentrated on checking some patches headed for
v5.9 (and some bugfix patches of my own that I don't get time to send):
I'll get back to responding on lru_lock in a week or two's time.

Hugh
