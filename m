From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/8] proc: Optimise smaps for shmem entries
Date: Wed, 26 Aug 2020 10:24:27 -0400
Message-ID: <20200826142427.GC988805@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-5-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=0MQzhYw1eFCZ4OasAAPt/4uM+WwEYftpqDc/VYHMtbk=;
 b=AEeeIKetXtIdWWb5SAUNf0CT75v612rlaNccc1LnuJpBb5OvgTvnreoT4A4OjAHh83
 2gkDSfW8afxE84LI039FqJeIhxV2oGZ4RnkHwrgT7gaJY5kFVxvgD7z3kcBB0nmwawYl
 CS15Jy0Be3rJh0nkvXUGExE957xE1b+7UhD8hCHGOAkgpPAPwOWMKzZ3o/gby8vQ+sfN
 wDB5+JA+w8e/Hdgudw8JPIy+J6slyE1vtbucRIPeRAxApuJujob6n7+1FX7GzcKFLkOs
 Chs9V5WR7ttQDJxLdP5QRuGU/ZbDFDC5QqvZOLj2rWLfNycVtJZza+7sI/jmL4cSLtEa
 UEUQ==
Content-Disposition: inline
In-Reply-To: <20200819184850.24779-5-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org, Matthew Auld <matthew.auld@intel.com>, Huang Ying <ying.huang@intel.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Aug 19, 2020 at 07:48:46PM +0100, Matthew Wilcox (Oracle) wrote:
> Avoid bumping the refcount on pages when we're only interested in the
> swap entries.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
