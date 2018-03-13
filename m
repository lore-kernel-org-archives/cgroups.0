From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/6] cgroup: Introduce task_get_dfl_cgroup()
Date: Tue, 13 Mar 2018 13:41:46 -0700
Message-ID: <20180313204146.GL2943022@devbig577.frc2.facebook.com>
References: <20180306234700.6562-1-matthew.d.roper@intel.com>
 <20180306234700.6562-3-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=RLZgJOkGlkRJYTSL6JGoePgy5kxZdJUW5d1xvqC0Tq4=;
 b=lh+gNWn50ydlVRa2NkdIveQUbSgfUOD7UYLlwmFldZwctD1w9X4ZhBQ7PjG27KjIRq
 WnIIjTljWK6W4hgwbRP5CkfhT9sfo8Q2BNli9LY5p7vkMpjFQ5RJg2Jij2rphDIMB7Hx
 ckpVDhDJRYkPNBsMTcUzsBaRrGrJnr6uHNZBFDHp/qgcH0gj2CEzrWtvwZXRudPDq5qg
 LGyQdEKx8DFw1aVbv3HSq6TQLNJa932Xv9/c1INm1jXQBCqBRymgTQo0p7nwZFPRhe3g
 dXa3Ndba4oRGkddqgmBO6heNpCB8XkvoHkD9990SgDK1PefG8jHz22jAQyo5bryZe/QS
 oh/A==
Content-Disposition: inline
In-Reply-To: <20180306234700.6562-3-matthew.d.roper@intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper@intel.com>
Cc: cgroups@vger.kernel.org, intel-gfx@lists.freedesktop.org, Roman Gushchin <guro@fb.com>, dri-devel@lists.freedesktop.org

KGNjJ2luZyBSb21hbikKCkhlbGxvLAoKT24gVHVlLCBNYXIgMDYsIDIwMTggYXQgMDM6NDY6NTZQ
TSAtMDgwMCwgTWF0dCBSb3BlciB3cm90ZToKPiArc3RhdGljIGlubGluZSBzdHJ1Y3QgY2dyb3Vw
ICoKPiArdGFza19nZXRfZGZsX2Nncm91cChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spCj4gK3sK
PiArCXN0cnVjdCBjZ3JvdXAgKmNncnA7Cj4gKwo+ICsJbXV0ZXhfbG9jaygmY2dyb3VwX211dGV4
KTsKPiArCWNncnAgPSB0YXNrX2RmbF9jZ3JvdXAodGFzayk7Cj4gKwljZ3JvdXBfZ2V0KGNncnAp
Owo+ICsJbXV0ZXhfdW5sb2NrKCZjZ3JvdXBfbXV0ZXgpOwoKSGVoLCB0aGlzIGlzIHN1cGVyIGhl
YXZ5LiAgQ2FuJ3Qgd2UgZG8gInJjdSwgdHJ5IGdldCwgY29tcGFyZSAmCnJldHJ5Ij8KClRoYW5r
cy4KCi0tIAp0ZWp1bgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2
ZWwK
