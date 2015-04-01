From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/memcg: update memcg/kmem status
Date: Wed, 1 Apr 2015 16:44:31 +0200
Message-ID: <20150401164431.1e88220a@lwn.net>
References: <1427898636-4505-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427898636-4505-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 1 Apr 2015 17:30:36 +0300
Vladimir Davydov <vdavydov@parallels.com> wrote:

> Memcg/kmem reclaim support has been finally merged. Reflect this in the
> documentation.

So the text you've removed says not to select kmem support "unless for
development purposes."  Do we now believe that this feature is ready for
use in a production setting?  If the answer is "yes," I'd be happy to
take this through the docs tree.

jon
